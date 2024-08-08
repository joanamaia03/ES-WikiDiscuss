import 'package:flutter/material.dart';

import '../resources/setting_methods.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode.background,
      appBar: AppBar(
        backgroundColor: mode.background,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            key: ValueKey("BackIconButton"),
          ),
          color: mode.letters,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                color: mode.letters,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.transparent, height: 48.0),
            buildExpansionTile(
              'How to reset my password?',
              'You can logout and then click on "Reset Password" button. You will receive an email with a link to reset your password.',
            ),
            const Divider(color: Colors.transparent, height: 16.0),
            buildExpansionTile(
              'How to contact team services',
              'To contact support team, please write email up202102355@fe.up.pt',
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildExpansionTile(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: mode.letters,
          fontSize: 17,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            content,
            style: TextStyle(
              color: mode.letters,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
