import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_discuss/screens/help_screen.dart';

void main() {
  group('HelpScreen', () {
    testWidgets('Screen is created correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const HelpScreen()));


      expect(find.text('Frequently Asked Questions'), findsOneWidget);
    });

    testWidgets('ExpansionTiles are created correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const HelpScreen()));


      expect(find.widgetWithText(ExpansionTile, 'How to reset my password?'), findsOneWidget);
      expect(find.widgetWithText(ExpansionTile, 'How to contact team services'), findsOneWidget);
    });
  });
}