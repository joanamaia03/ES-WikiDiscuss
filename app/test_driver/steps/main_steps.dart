import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric goToMain() {
  return given2<String, String, FlutterWorld>(
    'I am register user with email {string} and password {string} on main page',
        (email, password, context) async {
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
          final emailField = find.byValueKey("EmailTextField");
          await FlutterDriverUtils.enterText(context.world.driver, emailField, email);
          final passwordField = find.byValueKey("PasswordTextField");
          await FlutterDriverUtils.enterText(context.world.driver, passwordField, password);
          final loginButton = find.text('Sign In');
          await FlutterDriverUtils.tap(context.world.driver, loginButton);
          await Future.delayed(const Duration(seconds: 2));
          final finder = find.text('Search Wikipedia pages');
          context.expectMatch(
            await FlutterDriverUtils.isPresent(context.world.driver, finder),
            true
          );
        },
  );
}

String _getValueKeyFromIconName(String iconName) {
  switch (iconName) {
    case 'menu':
      return "MenuIconButton";
    case 'home':
      return 'HomeIconButton';
    case 'chat':
      return 'ChatIconButton';
    case 'send':
      return 'SendIconButton';
    case 'back':
      return 'BackIconButton';
    default:
      throw ArgumentError('Unsupported icon name: $iconName');
  }
}

StepDefinitionGeneric tapIconButton() {
  return when1<String, FlutterWorld>(
    'I tap the {string} icon button',
        (iconName, context) async {
      final buttonKey = _getValueKeyFromIconName(iconName);
      final targetButtonFinder = find.byValueKey(buttonKey);

      await FlutterDriverUtils.tap(context.world.driver, targetButtonFinder);
    },
  );
}

StepDefinitionGeneric seeHelpPage() {
  return then<FlutterWorld>(
    'I should see the help screen',
        (context) async {
      final finder = find.text('Frequently Asked Questions');
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder),
        true,
      );
    },
  );
}

StepDefinitionGeneric notSeeText() {
  return then1<String, FlutterWorld>(
    "I shouldn't see {string}",
        (error, context) async {
      final finder = find.text(error);
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder),
        false,
      );
    },
  );
}


