import 'package:flutter/material.dart';
import 'package:wiki_discuss/screens/reset_screen.dart';
import 'package:wiki_discuss/screens/sign_up_screen.dart';

import '../resources/auth_methods.dart';
import '../resources/setting_methods.dart';
import '../utils/utils.dart';
import '../widgets/build_text_field.dart';
import '../widgets/firebase_ui_button.dart';
import '../widgets/wiki_discuss.dart';
import 'main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future<String> loginUser() async {
    String res = await AuthMethods().loginUser(
        email: _emailTextController.text,
        password: _passwordTextController.text);
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
    return res;
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
                const SizedBox(height: 180.0),
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
                const SizedBox(height: 160.0),
                firebaseUIButton(context, "Sign In", () => loginUser()),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: Text(
            "Sign Up",
            style: TextStyle(color: mode.letters, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        forgetPassword(context),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return SizedBox(
      child: TextButton(
        child: Text(
          "Reset Password",
          style: TextStyle(color:mode.letters),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}