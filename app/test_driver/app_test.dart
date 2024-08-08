import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/auth_steps.dart';
import 'steps/main_steps.dart';
import 'steps/search_steps.dart';
import 'steps/chat_steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [
      //Glob(r"test_driver/features/login.feature"),
      //Glob(r"test_driver/features/register.feature"),
      //Glob(r"test_driver/features/help_screen.feature"),
      //Glob(r"test_driver/features/search_pages.feature"),
      Glob(r"test_driver/features/chat.feature"),
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json'),
    ]
    ..hooks = []
    ..stepDefinitions = [
      inLoginPage(),
      fillInField(),
      tapButton(),
      seeHomePage(),
      seeText(),
      notSeeText(),
      inRegisterPage(),
      seeRegPage(),
      seeLogPage(),
      goToMain(),
      tapIconButton(),
      seeHelpPage(),
      seePage(),
      notSeePage(),
      inPage(),
      seeChat(),
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}
