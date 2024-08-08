import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric seeChat() {
  return then<FlutterWorld>(
    'I should see chat page',
        (context) async {
      final finder = find.text("Portugal");
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder),
        true,
      );
      final finder2 = find.text("Send Message");
      context.expectMatch(
        await FlutterDriverUtils.isPresent(context.world.driver, finder2),
        true,
      );
      final wikiChatScreenFinder = find.byValueKey("SendTextField");
      final isPageOpened = await FlutterDriverUtils.isPresent(context.world.driver, wikiChatScreenFinder);
      context.expectMatch(isPageOpened, true);
      final wikiSendFinder = find.byValueKey("SendIconButton");
      final isSendIcon = await FlutterDriverUtils.isPresent(context.world.driver, wikiSendFinder);
      context.expectMatch(isSendIcon, true);
    },
  );
}