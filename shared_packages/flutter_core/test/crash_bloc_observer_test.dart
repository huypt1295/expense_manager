import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart';
import 'package:flutter_core/src/presentation/bloc/crash_bloc_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrashReporter extends Mock implements CrashReporter {}

class _DummyBloc extends Bloc<int, int> {
  _DummyBloc() : super(0);

  Stream<int> mapEventToState(int event) async* {}
}

void main() {
  late _MockCrashReporter crash;
  late CrashBlocObserver observer;
  late _DummyBloc bloc;

  setUp(() {
    crash = _MockCrashReporter();
    observer = CrashBlocObserver(crash);
    bloc = _DummyBloc();

    when(() => crash.addBreadcrumb(any(),
        category: any(named: 'category'),
        data: any(named: 'data'),
        level: any(named: 'level'))).thenReturn(null);
    when(() => crash.recordError(any(), any(), context: any(named: 'context')))
        .thenReturn(null);
  });

  test('onEvent records breadcrumb', () {
    observer.onEvent(bloc, 1);

    verify(() => crash.addBreadcrumb(
          'bloc.onEvent',
          category: '_DummyBloc',
          data: {'event': 'int'},
        )).called(1);
  });

  test('onChange records breadcrumb', () {
    observer.onChange(bloc, const Change(currentState: 1, nextState: 2));

    verify(() => crash.addBreadcrumb(
          'bloc.onChange',
          category: '_DummyBloc',
          data: {'current': 'int', 'next': 'int'},
        )).called(1);
  });

  test('onError forwards to crash reporter', () {
    final error = StateError('broken');
    final stack = StackTrace.current;

    observer.onError(bloc, error, stack);

    verify(() => crash.recordError(error, stack, context: {'bloc': '_DummyBloc'})).called(1);
  });
}
