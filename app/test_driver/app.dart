import 'package:firebase_core/firebase_core.dart';
import 'package:wiki_discuss/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';


import 'package:flutter/material.dart';
import 'package:wiki_discuss/firebase_options.dart';

void main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
