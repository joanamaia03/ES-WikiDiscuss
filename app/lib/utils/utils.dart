import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  // ignore: avoid_print
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
      content: Text("Email or Password is incorrect"),
      //content: Text(text),
      duration: Duration(seconds: 3),
    ),
  );
}

String timePassed(DateTime messageDate) {
  final now = DateTime.now();
  final difference = now.difference(messageDate);
  String time = '';

  if (difference.inDays > 0) {
    time = '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours > 0) {
    time = '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes > 0) {
    time = '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    time = 'Just now';
  }

  return time;
}