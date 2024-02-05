// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/signin.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPassword = TextEditingController();

  bool showIncorrectCredentials = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.8;
    double containerHeight = screenHeight * 0.7;

    double textFormFieldWith = screenWidth * 0.7;
    double textFormFieldHeight = screenHeight * 0.06;

    double buttonHeight = screenHeight * 0.05;

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              BackgroundImage(),
              Center(
                child: Container(
                  height: containerHeight,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color.fromRGBO(230, 244, 253, 61),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: reusableText("SIGNUP", 40, Colors.black),
                      ),
                      textField(textFormFieldHeight, textFormFieldWith,
                          "Enter email", false, _emailController),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      textField(textFormFieldHeight, textFormFieldWith,
                          "Enter password", true, _passwordController),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      textField(textFormFieldHeight, textFormFieldWith,
                          "Re-enter password", true, _reEnterPassword),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: reusableButton(
                          buttonHeight,
                          textFormFieldWith,
                          "SIGNUP",
                          () => signUp(context, _emailController.text,
                              _passwordController.text, _reEnterPassword.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: optionRow("Already have an account? ", "Login",
                            context, SigninScreen()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp(
      BuildContext context, String email, password, reEnterPassword) async {
    if (password != reEnterPassword) {
      setState(() {
        showIncorrectCredentials = true;
      });
      debugPrint("Passwords do not match");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          debugPrint("Signed up successfully!");
          setState(
            () {
              showIncorrectCredentials = false;
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SigninScreen(),
            ),
          );
        }
      } catch (e) {
        debugPrint("Trouble signing up. Please try again");
        showIncorrectCredentials = true;
      }
    }
  }
}
