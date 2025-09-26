/// Marker super-class for states emitted by presentation layer blocs.
///
/// Keeping states under a shared base class allows utilities and mixins to
/// apply common constraints without depending on specific implementations.
abstract class BaseBlocState {
  /// Creates a const state instance.
  const BaseBlocState();
}
