import 'package:flutter/material.dart';
import 'package:flutter_core/src/presentation/widgets/base_stateful_widget.dart';
import 'package:flutter_core/src/presentation/widgets/base_stateless_widget.dart';
import 'package:flutter_core/src/presentation/widgets/ui_actions.dart';
import 'package:flutter_test/flutter_test.dart';

class _LifecycleTracker extends BaseStatefulWidget {
  const _LifecycleTracker({required this.log, super.key});
  final List<String> log;

  @override
  State<StatefulWidget> createState() => _LifecycleTrackerState();
}

class _LifecycleTrackerState extends BaseState<_LifecycleTracker> {
  @override
  void onInitState() => widget.log.add('init');

  @override
  void onDependenciesChanged() => widget.log.add('deps');

  @override
  void onPostFrame() => widget.log.add('postFrame');

  @override
  void onDeactivate() => widget.log.add('deactivate');

  @override
  void onDispose() => widget.log.add('dispose');

  @override
  Widget build(BuildContext context) => const SizedBox();
}

class _TrackerInherited extends InheritedWidget {
  const _TrackerInherited({required this.value, required super.child});
  final int value;

  @override
  bool updateShouldNotify(_TrackerInherited oldWidget) => value != oldWidget.value;
}

class _StatelessLogger extends BaseStatelessWidget {
  const _StatelessLogger({required this.log});
  final List<String> log;

  @override
  void onPostBuild(BuildContext context) {
    log.add('postBuild');
  }

  @override
  Widget buildContent(BuildContext context) => const Text('stateless');
}

class _UiHost extends StatefulWidget {
  const _UiHost();

  @override
  State<_UiHost> createState() => _UiHostState();
}

class _UiHostState extends State<_UiHost> {
  late final UiActions actions = UiActions(this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('host')),
      body: const SizedBox.shrink(),
    );
  }
}

void main() {
  testWidgets('BaseState invokes lifecycle hooks in order', (tester) async {
    final log = <String>[];
    final key = GlobalKey<_LifecycleTrackerState>();

    await tester.pumpWidget(
      _TrackerInherited(
        value: 1,
        child: MaterialApp(home: _LifecycleTracker(log: log, key: key)),
      ),
    );
    await tester.pump();

    expect(log, containsAllInOrder(['init', 'postFrame']));

    // Trigger dependency change.
    await tester.pumpWidget(
      _TrackerInherited(
        value: 2,
        child: MaterialApp(home: _LifecycleTracker(log: log, key: key)),
      ),
    );
    await tester.pump();

    // Remove widget to trigger deactivate/dispose.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump();

    expect(log, containsAllInOrder(['deps', 'deactivate', 'dispose']));
  });

  testWidgets('BaseStatelessWidget runs onPostBuild once', (tester) async {
    final log = <String>[];

    await tester.pumpWidget(MaterialApp(home: _StatelessLogger(log: log)));
    await tester.pump();

    expect(find.text('stateless'), findsOneWidget);
    expect(log, ['postBuild']);
  });

  testWidgets('UiActions perform safe context operations', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: _UiHost()));
    final state = tester.state<_UiHostState>(find.byType(_UiHost));
    final actions = state.actions;

    var called = false;
    actions((ctx) => called = true);
    expect(called, isTrue);

    actions.showSnackBar(const SnackBar(content: Text('hello')));
    await tester.pump();
    expect(find.text('hello'), findsOneWidget);

    final dialogFuture = actions.showDialogSafe<String>(
      builder: (context) {
        // Pop immediately with a result.
        Future.microtask(() => Navigator.of(context).pop('done'));
        return const AlertDialog(title: Text('dialog'));
      },
    );
    await tester.pumpAndSettle();
    expect(await dialogFuture, 'done');

    // Push a route then maybePop
    Navigator.of(state.context).push(MaterialPageRoute(builder: (_) => const Text('page')));
    await tester.pumpAndSettle();
    expect(find.text('page'), findsOneWidget);
    actions.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('page'), findsNothing);
  });
}
