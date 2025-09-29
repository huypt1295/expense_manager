import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/context_utils.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('tpColors returns the registered AppColorSchemeExtension',
      (tester) async {
    final appColors = createAppColorSchemeExtension(color: Colors.green);
    AppColorSchemeExtension? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: <ThemeExtension<dynamic>>[appColors]),
        home: Builder(
          builder: (context) {
            result = context.tpColors;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(result, isNotNull);
    expect(result, same(appColors));
  });
}
