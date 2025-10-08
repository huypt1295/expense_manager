import 'package:flutter_core/src/domain/analytics/analytics_service.dart';
import 'package:flutter_core/src/domain/analytics/analytics_service_impl.dart';
import 'package:flutter_core/src/foundation/monitoring/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnalytics extends Mock implements Analytics {}

void main() {
  late _MockAnalytics analytics;
  late AnalyticsServiceImpl service;

  setUp(() {
    analytics = _MockAnalytics();
    service = AnalyticsServiceImpl(analytics);

    when(() => analytics.logEvent(any(), parameters: any(named: 'parameters')))
        .thenAnswer((_) async {});
    when(() => analytics.logScreenView(screenName: any(named: 'screenName'), screenClass: any(named: 'screenClass')))
        .thenAnswer((_) async {});
    when(() => analytics.setUserProperty(any(), any())).thenAnswer((_) async {});
    when(() => analytics.setUserProperties(any())).thenAnswer((_) async {});
    when(() => analytics.setUserId(any())).thenAnswer((_) async {});
    when(() => analytics.reset()).thenAnswer((_) async {});
  });

  test('appOpen logs optional source parameter', () async {
    await service.appOpen(source: 'push');

    verify(() => analytics.logEvent('app_open', parameters: {'source': 'push'})).called(1);
  });

  test('screenView delegates to analytics adapter', () async {
    await service.screenView('Home', screenClass: 'HomePage');

    verify(() => analytics.logScreenView(screenName: 'Home', screenClass: 'HomePage'))
        .called(1);
  });

  test('login logs event and updates user context', () async {
    await service.login(method: 'google', userId: '42');

    verifyInOrder([
      () => analytics.logEvent('login', parameters: {'method': 'google'}),
      () => analytics.setUserProperty('auth_method', 'google'),
      () => analytics.setUserId('42'),
    ]);
  });

  test('logout resets analytics state', () async {
    await service.logout();

    verify(() => analytics.reset()).called(1);
    verify(() => analytics.logEvent('logout', parameters: const {})).called(1);
  });

  test('flowResult sanitizes keys and values', () async {
    await service.flowResult(
      flow: 'PaymentFlow',
      status: 'success',
      extra: {
        'UserId': 'abc',
        'metadata': {'CamelCase': 1},
      },
    );

    verify(() => analytics.logEvent('payment_flow_result', parameters: {
          'status': 'success',
          'user_id': 'abc',
          'metadata': {'camel_case': 1},
        })).called(1);
  });

  test('purchase maps GAItem list', () async {
    const items = [
      GAItem(
        itemId: 'sku_1',
        itemName: 'Plan',
        quantity: 2,
        price: 9.99,
        itemBrand: 'ACME',
        itemCategory: 'Subs',
        coupon: 'SAVE',
      ),
    ];

    await service.purchase(
      transactionId: 'tx1',
      currency: 'USD',
      value: 19.98,
      items: items,
      tax: 2,
      shipping: 1,
      coupon: 'SAVE',
      paymentMethod: 'card',
    );

    final captured = verify(() => analytics.logEvent('purchase', parameters: captureAny(named: 'parameters')))
        .captured
        .single as Map<String, Object?>;

    expect(captured['transaction_id'], 'tx1');
    expect(captured['items'], isA<List>());
    final item = (captured['items'] as List).single as Map<String, Object?>;
    expect(item['item_id'], 'sku_1');
    expect(item['item_brand'], 'ACME');
    expect(item['coupon'], 'SAVE');
  });
}
