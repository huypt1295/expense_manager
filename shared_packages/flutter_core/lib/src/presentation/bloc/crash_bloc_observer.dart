import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart' show singleton, CrashReporter;

/// Observes bloc lifecycle events and reports them to the crash reporter.
@singleton
class CrashBlocObserver extends BlocObserver {
  final CrashReporter _crash;

  CrashBlocObserver(this._crash);

  @override
  void onEvent(Bloc bloc, Object? event) {
    _crash.addBreadcrumb(
      'bloc.onEvent',
      category: bloc.runtimeType.toString(),
      data: {
        'event': event?.runtimeType.toString(),
      },
    );
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    _crash.addBreadcrumb(
      'bloc.onChange',
      category: bloc.runtimeType.toString(),
      data: {
        'current': change.currentState.runtimeType.toString(),
        'next': change.nextState.runtimeType.toString(),
      },
    );
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _crash.recordError(
      error,
      stackTrace,
      context: {'bloc': bloc.runtimeType.toString()},
    );
    super.onError(bloc, error, stackTrace);
  }
}
