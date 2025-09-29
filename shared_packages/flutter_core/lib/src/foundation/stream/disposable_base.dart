/// Contract describing disposable resources managed by [DisposeBag].
abstract class DisposableBase {
  /// Releases the resources held by this instance.
  void dispose();
}
