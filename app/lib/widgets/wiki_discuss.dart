import 'package:flutter/material.dart';

import '../resources/setting_methods.dart';

class WikiDiscuss extends StatefulWidget {
  const WikiDiscuss({Key? key}) : super(key: key);

  @override
  State<WikiDiscuss> createState() => _WikiDiscussState();
}

class _WikiDiscussState extends State<WikiDiscuss> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Wiki\nDiscuss',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 40.0,
          color: mode.letters,
          height: 0.8,
          fontWeight: FontWeight.bold,
          fontFamily: 'Asar',
      ),
    );
  }
}
