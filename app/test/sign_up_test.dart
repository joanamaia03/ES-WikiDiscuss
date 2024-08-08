import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_discuss/screens/sign_in_screen.dart';
import 'package:wiki_discuss/screens/sign_up_screen.dart';

void main() {
  group('SignUpScreen', () {
    late TextEditingController nameController;
    late TextEditingController emailController;
    late TextEditingController passwordController;
    late TextEditingController confPasswordController;

    setUp(() {
      nameController = TextEditingController();
      emailController = TextEditingController();
      passwordController = TextEditingController();
      confPasswordController = TextEditingController();
    });

    testWidgets('renders Name, Email, Password and Confirm Password TextFields',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: SignUpScreen(),
            ),
          );

          final nameFieldFinder = find.byKey(const ValueKey('NameTextField'));
          final emailFieldFinder = find.byKey(const ValueKey('EmailTextField'));
          final passwordFieldFinder = find.byKey(const ValueKey('PasswordTextField'));
          final confPasswordFieldFinder = find.byKey(const ValueKey('ConfPasswordTextField'));

          expect(nameFieldFinder, findsOneWidget);
          expect(emailFieldFinder, findsOneWidget);
          expect(passwordFieldFinder, findsOneWidget);
          expect(confPasswordFieldFinder, findsOneWidget);
        });

    tearDown(() {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confPasswordController.dispose();
    });
  });
}