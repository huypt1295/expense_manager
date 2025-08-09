
abstract class BaseUseCase<Params, T> {
  Future<T> call(Params params);
}