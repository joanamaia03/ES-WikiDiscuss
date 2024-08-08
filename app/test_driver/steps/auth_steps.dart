import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';


StepDefinitionGeneric fillInField() {
  return given2<String, String, FlutterWorld>(
    'I fill in {string} with {string}',
        (key, value, context) async {
      final field = find.byValueKey(key);
      await FlutterDriverUtils.enterText(
        context.world.driver,
        field,
        value,
      );
    },
  );
}

StepDefinitionGeneric tapButton() {
  return when1<String, FlutterWorld>(
    'I tap the {string} button',
        (text, context) async {
      final loginButton = find.text(text);
      await FlutterDriverUtils.tap(context.world.driver, loginButton);
    },
  );
}

StepDefinitionGeneric seeHomePage() {
  return then<FlutterWorld>(
    'I should see the home page',
        (context) async {
          await Future.delayed(const Duration(seconds: 2)); // Wait for the widget tree to update
          final finder = find.text('Search Wikipedia pages');
          context.expectMatch(
            await FlutterDriverUtils.isPresent(context.world.driver, finder),
            true,
          );
    },
  );
}

StepDefinitionGeneric seeRegPage() {
  return then<FlutterWorld>(
    'I should see the register page',
        (context) async {
      final  finder3 = find.text('Register');
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder3),
        true,
      );
    },
  );
}

StepDefinitionGeneric seeLogPage() {
  return then<FlutterWorld>(
    'I should see the login page',
        (context) async {
      final  finder3 = find.text('Sign In');
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder3),
        true,
      );
    },
  );
}

StepDefinitionGeneric seeText() {
  return then1<String, FlutterWorld>(
    'I should see {string}',
        (error, context) async {
      final finder = find.text(error);
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder),
        true,
      );
    },
  );
}

StepDefinitionGeneric inRegisterPage() {
  return given<FlutterWorld>(
    'I am in the register page',
        (context) async {
          final start = find.text('Get Started');
          final isStart = await FlutterDriverUtils.isPresent(context.world.driver, start);
          if(isStart){
            final goToLogin = find.text('Get Started');
            await FlutterDriverUtils.tap(context.world.driver, goToLogin);
          }
          final main = find.text('Search Wikipedia pages');
          final isMain = await FlutterDriverUtils.isPresent(context.world.driver, main);
          if(isMain){
            final targetButtonFinder = find.byValueKey("MenuIconButton");
            await FlutterDriverUtils.tap(context.world.driver, targetButtonFinder);
            final profileButton = find.text('Profile');
            await FlutterDriverUtils.tap(context.world.driver, profileButton);
            final logoutButton = find.text('Logout');
            await FlutterDriverUtils.tap(context.world.driver, logoutButton);
          }
      final goToRegister = find.text("Sign Up");
      await FlutterDriverUtils.tap(context.world.driver, goToRegister);
      final registerButton = find.text('Register');
      context.expectMatch(
        await FlutterDriverUtils.isPresent(
            context.world.driver, registerButton),
        true,
      );
    },
  );
}

StepDefinitionGeneric inLoginPage() {
  return given<FlutterWorld>(
    'I am in the login page',
        (context) async {
          final start = find.text('Get Started');
          final isStart = await FlutterDriverUtils.isPresent(context.world.driver, start);
          if(isStart){
            final goToLogin = find.text('Get Started');
            await FlutterDriverUtils.tap(context.world.driver, goToLogin);
          }
          final main = find.text('Search Wikipedia pages');
          final isMain = await FlutterDriverUtils.isPresent(context.world.driver, main);
          if(isMain){
            final targetButtonFinder = find.byValueKey("MenuIconButton");
            await FlutterDriverUtils.tap(context.world.driver, targetButtonFinder);
            final profileButton = find.text('Profile');
            await FlutterDriverUtils.tap(context.world.driver, profileButton);
            final logoutButton = find.text('Logout');
            await FlutterDriverUtils.tap(context.world.driver, logoutButton);
          }

      final loginButton = find.text('Sign In');
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, loginButton),
        true,
      );
    },
  );
}