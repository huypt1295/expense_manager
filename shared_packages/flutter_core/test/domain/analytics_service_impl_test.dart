import 'package:flutter_core/src/domain/analytics/analytics_service.dart';
import 'package:flutter_core/src/domain/analytics/analytics_service_impl.dart';
import 'package:flutter_core/src/foundation/monitoring/analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAnalytics implements Analytics {
  final List<Map<String, Object?>> events = [];
  final List<Map<String, Object?>> screenViews = [];
  final List<MapEntry<String, String?>> userProps = [];
  final List<Map<String, Object?>> userPropsBatch = [];
  String? userId;
  bool enabled = true;
  int resetCalls = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {
    events.add({'name': name, 'params': parameters});
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    screenViews.add({'screenName': screenName, 'screenClass': screenClass});
  }

  @override
  Future<void> reset() async {
    resetCalls++;
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    this.enabled = enabled;
  }

  @override
  Future<void> setUserId(String? id) async {
    userId = id;
  }

  @override
  Future<void> setUserProperties(Map<String, String?> props) async {
    userPropsBatch.add(props);
  }

  @override
  Future<void> setUserProperty(String key, String? value) async {
    userProps.add(MapEntry(key, value));
  }
}

void main() {
  group('AnalyticsServiceImpl', () {
    late _FakeAnalytics fake;
    late AnalyticsService service;

    setUp(() {
      fake = _FakeAnalytics();
      service = AnalyticsServiceImpl(fake);
    });

    test('appOpen logs event with optional source', () async {
      await service.appOpen(source: 'deep_link');

      expect(fake.events.single['name'], 'app_open');
      expect(fake.events.single['params'], {'source': 'deep_link'});
    });

    test('login logs event, sets property and user id', () async {
      await service.login(method: 'password', userId: '42');

      expect(fake.events.single['name'], 'login');
      expect(fake.events.single['params'], {'method': 'password'});
      expect(fake.userProps.single.key, 'auth_method');
      expect(fake.userProps.single.value, 'password');
      expect(fake.userId, '42');
    });

    test('flowStart sanitizes metadata keys to snake_case', () async {
      await service.flowStart(
        flow: 'CheckoutFlow',
        extra: {'User ID': 99, 'Step#': 'Confirm'},
      );

      final event = fake.events.single;
      expect(event['name'], 'checkout_flow_start');
      expect(event['params'], {'user__i_d': 99, 'step_': 'Confirm'});
    });

    test('flowResult includes status and merges metadata', () async {
      await service.flowResult(
        flow: 'RecoveryFlow',
        status: 'success',
        extra: {'Retry Count': 2},
      );

      final event = fake.events.single;
      expect(event['name'], 'recovery_flow_result');
      expect(event['params'], {'status': 'success', 'retry__count': 2});
    });

    test('purchase maps GAItem list into event payload', () async {
      await service.purchase(
        transactionId: 'tx123',
        currency: 'USD',
        value: 42.5,
        items: const [
          GAItem(
            itemId: '1',
            itemName: 'Book',
            quantity: 2,
            price: 10,
            itemBrand: 'Acme',
          ),
          GAItem(
            itemId: '2',
            itemName: 'Pen',
            quantity: 1,
            price: 5,
            coupon: 'SAVE',
          ),
        ],
        tax: 2,
        shipping: 5,
        coupon: 'BUNDLE',
        paymentMethod: 'card',
      );

      final event = fake.events.single;
      expect(event['name'], 'purchase');
      expect(event['params'], {
        'transaction_id': 'tx123',
        'currency': 'USD',
        'value': 42.5,
        'tax': 2,
        'shipping': 5,
        'coupon': 'BUNDLE',
        'payment_method': 'card',
        'items': [
          {
            'item_id': '1',
            'item_name': 'Book',
            'quantity': 2,
            'price': 10,
            'item_brand': 'Acme',
          },
          {
            'item_id': '2',
            'item_name': 'Pen',
            'quantity': 1,
            'price': 5,
            'coupon': 'SAVE',
          },
        ],
      });
    });

    test('refund omits empty collections', () async {
      await service.refund(
        transactionId: 'tx123',
        currency: 'USD',
        reason: 'duplicate',
      );

      final event = fake.events.single;
      expect(event['name'], 'refund');
      expect(event['params'], {
        'transaction_id': 'tx123',
        'currency': 'USD',
        'reason': 'duplicate',
      });
    });

    test('chargeback logs reason and network when provided', () async {
      await service.chargeback(
        transactionId: 'tx1',
        currency: 'USD',
        value: 20,
        reason: 'fraud',
        network: 'visa',
      );

      final event = fake.events.single;
      expect(event['name'], 'chargeback');
      expect(event['params'], {
        'transaction_id': 'tx1',
        'currency': 'USD',
        'value': 20,
        'reason': 'fraud',
        'network': 'visa',
      });
    });
  });
}
