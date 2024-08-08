import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_discuss/screens/sign_in_screen.dart';
import 'package:wiki_discuss/screens/sign_up_screen.dart';
import 'package:wiki_discuss/screens/reset_screen.dart';


import 'package:flutter/widgets.dart';



void main() async{

  group('SignInScreen', () {

    testWidgets('should display email and password text fields',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: SignInScreen()));

          final emailTextField = find.byKey(ValueKey('EmailTextField'));
          final passwordTextField = find.byKey(ValueKey('PasswordTextField'));

          expect(emailTextField, findsOneWidget);
          expect(passwordTextField, findsOneWidget);
        });

    testWidgets('should display Sign In button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInScreen()));

      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

      expect(signInButton, findsOneWidget);
    });

    testWidgets('Tap on Sign Up button navigates to SignUpScreen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInScreen()));

      // Find the Sign Up button
      final signUpFinder = find.text('Sign Up');
      expect(signUpFinder, findsOneWidget);

      // Scroll the widget into view
      await tester.ensureVisible(signUpFinder);

      // Tap on the Sign Up button
      await tester.tap(signUpFinder);
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });

    testWidgets('Tap on Reset Password button navigates to ResetPasswordScreen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignInScreen()));

      final resetPasswordFinder = find.text('Reset Password');
      expect(resetPasswordFinder, findsOneWidget);

      // Scroll the widget into view
      await tester.ensureVisible(resetPasswordFinder);

      // Tap on the Reset Password button
      await tester.tap(resetPasswordFinder);
      await tester.pumpAndSettle();

      expect(find.byType(ResetPassword), findsOneWidget);
    });

  });
}