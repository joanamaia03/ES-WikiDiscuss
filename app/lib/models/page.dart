import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Page {
  final String title;
  final String pid;
  final int count;

  const Page({
    required this.count,
    required this.pid,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "pageid": pid,
    "count": count,
  };
}