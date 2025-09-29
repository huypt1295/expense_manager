/// Defines the analytics contract used by the application to report usage
/// events to the underlying tracking provider.
abstract class AnalyticsService {
  /// Tracks an app open event, optionally tagging the entry [source].
  Future<void> appOpen({String? source});

  /// Logs a screen view with the provided [screenName] and optional
  /// [screenClass] hint for the analytics backend.
  Future<void> screenView(String screenName, {String? screenClass});

  /// Records a user login, capturing the authentication [method] and optional
  /// [userId] when available.
  Future<void> login({required String method, String? userId});

  /// Clears any user context and tracks a logout event.
  Future<void> logout();

  /// Marks the beginning of a named [flow] with additional [extra] metadata.
  Future<void> flowStart({required String flow, Map<String, Object?> extra});

  /// Logs the result of a named [flow] with the outcome [status] and
  /// additional [extra] data.
  Future<void> flowResult({required String flow, required String status, Map<String, Object?> extra});

  /// Records a purchase event with transaction details and the purchased
  /// [items].
  Future<void> purchase({
    required String transactionId,
    required String currency,
    required num value,
    required List<GAItem> items,
    num? tax,
    num? shipping,
    String? coupon,
    String? paymentMethod,
  });

  /// Records a refund for the transaction with identifier [transactionId].
  Future<void> refund({
    required String transactionId,
    required String currency,
    num? value,
    List<GAItem>? items,
    String? reason,
  });

  /// Records a chargeback initiated against the transaction identified by
  /// [transactionId].
  Future<void> chargeback({
    required String transactionId,
    required String currency,
    required num value,
    String? reason,
    String? network,
  });
}

/// Represents a single line item included in a commerce analytics event.
class GAItem {
  final String itemId;
  final String itemName;
  final int quantity;
  final num price;
  final String? itemBrand;
  final String? itemCategory;
  final String? itemCategory2;
  final String? itemVariant;
  final String? coupon;

  const GAItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    this.itemBrand,
    this.itemCategory,
    this.itemCategory2,
    this.itemVariant,
    this.coupon,
  });
}
