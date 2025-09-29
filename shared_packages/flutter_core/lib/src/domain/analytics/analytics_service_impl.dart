import 'package:injectable/injectable.dart';
import '../../foundation/monitoring/analytics.dart';
import 'analytics_service.dart';

/// Default [AnalyticsService] implementation backed by the shared
/// [Analytics] abstraction.
@LazySingleton(as: AnalyticsService)
class AnalyticsServiceImpl implements AnalyticsService {
  final Analytics _a;
  AnalyticsServiceImpl(this._a);

  @override
  Future<void> appOpen({String? source}) => _a.logEvent('app_open', parameters: { if (source != null) 'source': source });

  @override
  Future<void> screenView(String screenName, {String? screenClass}) =>
      _a.logScreenView(screenName: screenName, screenClass: screenClass);

  @override
  Future<void> login({required String method, String? userId}) async {
    await _a.logEvent('login', parameters: {'method': method});
    await _a.setUserProperty('auth_method', method);
    await _a.setUserId(userId);
  }

  @override
  Future<void> logout() async {
    await _a.reset();
    await _a.logEvent('logout');
  }

  @override
  Future<void> flowStart({required String flow, Map<String, Object?> extra = const {}}) =>
      _a.logEvent('${_snake(flow)}_start', parameters: _safe(extra));

  @override
  Future<void> flowResult({required String flow, required String status, Map<String, Object?> extra = const {}}) =>
      _a.logEvent('${_snake(flow)}_result', parameters: {'status': status, ..._safe(extra)});

  @override
  Future<void> purchase({
    required String transactionId,
    required String currency,
    required num value,
    required List<GAItem> items,
    num? tax,
    num? shipping,
    String? coupon,
    String? paymentMethod,
  }) {
    return _a.logEvent('purchase', parameters: {
      'transaction_id': transactionId,
      'currency': currency,
      'value': value,
      if (tax != null) 'tax': tax,
      if (shipping != null) 'shipping': shipping,
      if (coupon != null) 'coupon': coupon,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      'items': items.map(_mapItem).toList(),
    });
  }

  @override
  Future<void> refund({
    required String transactionId,
    required String currency,
    num? value,
    List<GAItem>? items,
    String? reason,
  }) {
    return _a.logEvent('refund', parameters: {
      'transaction_id': transactionId,
      'currency': currency,
      if (value != null) 'value': value,
      if (items != null && items.isNotEmpty) 'items': items.map(_mapItem).toList(),
      if (reason != null) 'reason': reason,
    });
  }

  @override
  Future<void> chargeback({
    required String transactionId,
    required String currency,
    required num value,
    String? reason,
    String? network,
  }) {
    return _a.logEvent('chargeback', parameters: {
      'transaction_id': transactionId,
      'currency': currency,
      'value': value,
      if (reason != null) 'reason': reason,
      if (network != null) 'network': network,
    });
  }

  /// Converts a [GAItem] into an analytics payload compatible with the
  /// underlying SDK.
  Map<String, Object?> _mapItem(GAItem i) => {
    'item_id': i.itemId,
    'item_name': i.itemName,
    'quantity': i.quantity,
    'price': i.price,
    if (i.itemBrand != null) 'item_brand': i.itemBrand,
    if (i.itemCategory != null) 'item_category': i.itemCategory,
    if (i.itemCategory2 != null) 'item_category2': i.itemCategory2,
    if (i.itemVariant != null) 'item_variant': i.itemVariant,
    if (i.coupon != null) 'coupon': i.coupon,
  };

  /// Normalizes user supplied analytics metadata into snake_case keys and
  /// serializable values.
  Map<String, Object?> _safe(Map<String, Object?> src) =>
      src.map((k, v) => MapEntry(_snake(k), _val(v)));

  /// Produces a snake_case representation for the given [key].
  String _snake(Object key) {
    final s = key.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      if (_isUpper(c) && i > 0 && s[i - 1] != '_') buf.write('_');
      buf.write(c.toLowerCase());
    }
    final out = buf.toString().replaceAll(RegExp('[^a-z0-9_]+'), '_');
    return RegExp('^[0-9]').hasMatch(out) ? '_$out' : out;
  }

  /// Indicates whether [c] is an uppercase character.
  bool _isUpper(String c) => c.toUpperCase() == c && c.toLowerCase() != c;

  /// Coerces arbitrary metadata values into a type acceptable by the analytics
  /// provider.
  Object? _val(Object? v) {
    if (v == null || v is num || v is String || v is bool) return v;
    if (v is Iterable) return v.map(_val).toList();
    if (v is Map) return v.map((k, vv) => MapEntry(_snake(k), _val(vv)));
    return v.toString();
  }
}
