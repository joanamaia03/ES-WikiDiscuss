import 'package:flutter/material.dart';
import 'package:wiki_discuss/screens/sign_in_screen.dart';

import '../resources/auth_methods.dart';
import '../resources/setting_methods.dart';
import '../utils/utils.dart';
import '../widgets/build_text_field.dart';
import '../widgets/firebase_ui_button.dart';
import '../widgets/wiki_discuss.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _confPasswordTextController =
  TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  void signUpUser() async {
    String res = await AuthMethods().signUpUser(
      email: _emailTextController.text,
      password: _passwordTextController.text,
      confpassword: _confPasswordTextController.text,
      username: _userNameTextController.text,
    );
    if (res == "success") {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const WikiDiscuss(),
                const SizedBox(height: 130.0),
                BuildTextField(
                  key: const ValueKey('NameTextField'),
                  controller: _userNameTextController,
                  hintText: 'Name',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16.0),
                BuildTextField(
                  key: const ValueKey('EmailTextField'),
                  controller: _emailTextController,
                  hintText: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 16.0),
                BuildTextField(
                  key: const ValueKey('PasswordTextField'),
                  controller: _passwordTextController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 16),
                BuildTextField(
                  key: const ValueKey('ConfPasswordTextField'),
                  controller: _confPasswordTextController,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 92.0),
                firebaseUIButton(context, 'Register', () => signUpUser()),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(color: mode.letters),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}