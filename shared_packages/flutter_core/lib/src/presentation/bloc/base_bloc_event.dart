/// Marker super-class for bloc events within the presentation layer.
///
/// Extending this class keeps event declarations consistent across features
/// and eases dependency injection and testing.
abstract class BaseBlocEvent {
  /// Creates a const event.
  const BaseBlocEvent();
}
