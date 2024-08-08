import 'package:flutter/material.dart';

import '../resources/setting_methods.dart';

class BuildTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;

  const BuildTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hintText == 'Password' || hintText == 'Confirm Password',
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: mode.letters),
        prefixIcon: Icon(
          prefixIcon,
          color: mode.letters,
        ),
      ),
      style: TextStyle(
        color: mode.letters,
      ),
    );
  }
}