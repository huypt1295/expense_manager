import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart';
import 'package:flutter_core/src/presentation/bloc/crash_bloc_observer.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCrashReporter implements CrashReporter {
  final List<(String message, String? category, Map<String, Object?>? data)>
  breadcrumbs = [];
  final List<(Object error, StackTrace? stack, Map<String, Object?>? context)>
  errors = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> setEnabled(bool enabled) async {}

  @override
  void recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    Map<String, Object?>? context,
  }) {
    errors.add((error, stack, context));
  }

  @override
  void recordFlutterError(FlutterErrorDetails details) {}

  @override
  void log(String message, {Map<String, Object?>? data}) {}

  @override
  void addBreadcrumb(
    String message, {
    String? category,
    Map<String, Object?>? data,
    String? level,
  }) {
    breadcrumbs.add((message, category, data));
  }

  @override
  void setUser({String? id, String? email, String? name}) {}

  @override
  void setCustomKey(String key, Object? value) {}

  @override
  void setCustomKeys(Map<String, Object?> keys) {}
}

class _DummyBloc extends Bloc<int, int> {
  _DummyBloc() : super(0);

  Stream<int> mapEventToState(int event) async* {}
}

void main() {
  late _FakeCrashReporter crash;
  late CrashBlocObserver observer;

  setUp(() {
    crash = _FakeCrashReporter();
    observer = CrashBlocObserver(crash);
  });

  test('records breadcrumb on bloc event', () {
    final bloc = _DummyBloc();
    observer.onEvent(bloc, 1);

    expect(crash.breadcrumbs.single.$1, 'bloc.onEvent');
    expect(crash.breadcrumbs.single.$2, '_DummyBloc');
    expect(crash.breadcrumbs.single.$3, {'event': 'int'});
    bloc.close();
  });

  test('records breadcrumb on state change', () {
    final bloc = _DummyBloc();
    observer.onChange(bloc, Change<int>(currentState: 0, nextState: 1));

    expect(crash.breadcrumbs.single.$1, 'bloc.onChange');
    expect(crash.breadcrumbs.single.$3, {'current': 'int', 'next': 'int'});
    bloc.close();
  });

  test('records error with bloc context', () {
    final bloc = _DummyBloc();
    final stack = StackTrace.current;

    observer.onError(bloc, StateError('boom'), stack);

    expect(crash.errors.single.$1, isA<StateError>());
    expect(crash.errors.single.$3, {'bloc': '_DummyBloc'});
    bloc.close();
  });
}
