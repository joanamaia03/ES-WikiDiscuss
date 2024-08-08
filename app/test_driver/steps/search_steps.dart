import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric seePage() {
  return then1<String, FlutterWorld>(
    "I see {string} page",
        (pageTitle, context) async {
      await Future.delayed(const Duration(seconds: 1));
      final wikiPageScreenFinder = find.byValueKey('WikiPageScreen:' + pageTitle);
      final isPageOpened = await FlutterDriverUtils.isPresent(context.world.driver, wikiPageScreenFinder);
      context.expectMatch(isPageOpened, true);
    },
  );
}

StepDefinitionGeneric notSeePage() {
  return then1<String, FlutterWorld>(
    "I not see {string} page",
        (pageTitle, context) async {
      await Future.delayed(const Duration(seconds: 1));
      final wikiPageScreenFinder = find.byValueKey('WikiPageScreen:' + pageTitle);
      final isPageOpened = await FlutterDriverUtils.isPresent(context.world.driver, wikiPageScreenFinder);
      context.expectMatch(isPageOpened, false);
    },
  );
}

StepDefinitionGeneric inPage() {
  return given<FlutterWorld>(
    'I am on some page',
        (context) async {
      final field = find.byValueKey("SearchTextField");
      await FlutterDriverUtils.enterText(
        context.world.driver,
        field,
        "portugal",
      );
      await Future.delayed(const Duration(seconds: 2));
      final button = find.text("Portugal");
      await FlutterDriverUtils.tap(context.world.driver, button);
      await Future.delayed(const Duration(seconds: 2));
      final wikiPageScreenFinder = find.byValueKey('WikiPageScreen:' "Portugal");
      final isPageOpened = await FlutterDriverUtils.isPresent(context.world.driver, wikiPageScreenFinder);
      context.expectMatch(isPageOpened, true);
    },
  );
}