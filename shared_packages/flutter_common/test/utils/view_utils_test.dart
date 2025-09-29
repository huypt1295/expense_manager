import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/src/utils/view_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel platformChannel = SystemChannels.platform;

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platformChannel, null);
  });

  testWidgets('showAppSnackBar displays the provided message', (tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    ViewUtils.showAppSnackBar(capturedContext, 'Hello SnackBar');
    await tester.pump();

    expect(find.text('Hello SnackBar'), findsOneWidget);

    ViewUtils.showAppSnackBar(capturedContext, 'Updated Message');
    await tester.pump();

    expect(find.text('Updated Message'), findsOneWidget);
    expect(find.text('Hello SnackBar'), findsNothing);
  });

  testWidgets('hideKeyboard unfocuses the current focus node', (tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(focusNode: focusNode),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    ViewUtils.hideKeyboard(tester.element(find.byType(Scaffold)));
    await tester.pump();

    expect(focusNode.hasFocus, isFalse);
  });

  testWidgets('setPreferredOrientations forwards to platform channel',
      (tester) async {
    final calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platformChannel, (MethodCall call) async {
      calls.add(call);
      return null;
    });

    await ViewUtils.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);

    expect(calls, hasLength(1));
    expect(calls.first.method, 'SystemChrome.setPreferredOrientations');
    expect(calls.first.arguments, <String>['DeviceOrientation.portraitUp']);
  });

  testWidgets('setSystemUIOverlayStyle forwards to platform channel',
      (tester) async {
    final calls = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platformChannel, (MethodCall call) async {
      calls.add(call);
      return null;
    });

    ViewUtils.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    expect(calls, hasLength(1));
    expect(calls.first.method, 'SystemChrome.setSystemUIOverlayStyle');
    expect(calls.first.arguments, isA<Map<Object?, Object?>>());
  });

  testWidgets('getWidgetPosition, width and height return metrics',
      (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: key,
              width: 120,
              height: 48,
            ),
          ),
        ),
      ),
    );

    final position = ViewUtils.getWidgetPosition(key);
    final width = ViewUtils.getWidgetWidth(key);
    final height = ViewUtils.getWidgetHeight(key);

    expect(position, isNotNull);
    expect(position, const Offset(0, 0));
    expect(width, 120);
    expect(height, 48);
  });
}
