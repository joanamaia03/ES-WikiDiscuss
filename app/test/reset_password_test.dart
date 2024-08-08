import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_discuss/screens/reset_screen.dart';
import 'package:wiki_discuss/widgets/build_text_field.dart';

void main() {
  group('ResetPassword', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('renders the Reset Password page correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResetPassword(),
        ),
      );

      // Procura o título "Reset Password"
      final titleFinder = find.text('Reset Password');
      expect(titleFinder, findsNWidgets(2));

      // Procura o campo de texto "Enter Email Id"
      final emailFieldFinder = find.widgetWithText(BuildTextField, 'Enter Email');
      expect(emailFieldFinder, findsOneWidget);

      // Procura o botão "Reset Password"
      final buttonFinder = find.widgetWithText(ElevatedButton, 'Reset Password');
      expect(buttonFinder, findsOneWidget);
    });

    tearDown(() {
      controller.dispose();
    });
  });
}