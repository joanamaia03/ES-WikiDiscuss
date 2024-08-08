import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_discuss/widgets/build_text_field.dart';

void main() {
  group('BuildTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('renders the correct hintText', (WidgetTester tester) async {
      const hintText = 'Enter your name';
      const prefixIcon = Icons.person;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BuildTextField(
              hintText: hintText,
              prefixIcon: prefixIcon,
              controller: controller,
            ),
          ),
        ),
      );

      final hintTextFinder = find.text(hintText);
      expect(hintTextFinder, findsOneWidget);
    });

    testWidgets('applies obscureText to password fields',
            (WidgetTester tester) async {
          const hintText = 'Password';
          const prefixIcon = Icons.lock;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BuildTextField(
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  controller: controller,
                ),
              ),
            ),
          );

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.obscureText, true);
        });

    testWidgets('does not apply obscureText to non-password fields',
            (WidgetTester tester) async {
          const hintText = 'Enter your name';
          const prefixIcon = Icons.person;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BuildTextField(
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  controller: controller,
                ),
              ),
            ),
          );

          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(textField.obscureText, false);
        });

    tearDown(() {
      controller.dispose();
    });
  });
}