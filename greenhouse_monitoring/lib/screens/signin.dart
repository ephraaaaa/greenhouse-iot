// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/navigation.dart';
import 'package:greenhouse_monitoring/screens/signup.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool showIncorrectCredentials = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // COLORS :
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.8;
    double containerHeight = screenHeight * 0.45;

    double textFormFieldWith = screenWidth * 0.7;
    double textFormFieldHeight = screenHeight * 0.055;

    double buttonHeight = screenHeight * 0.05;

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              const BackgroundImage(),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color.fromRGBO(230, 244, 253, 61),
                  ),
                  height: containerHeight,
                  width: containerWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      reusableText("LOGIN", 40, Colors.black),
                      reusableSizedBox(screenHeight * 0.03),
                      textField(textFormFieldHeight, textFormFieldWith, "Email",
                          false, _emailController),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      textField(textFormFieldHeight, textFormFieldWith,
                          "Password", true, _passwordController),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      reusableButton(
                        buttonHeight,
                        textFormFieldWith,
                        "LOGIN",
                        () => signIn(context, _emailController.text,
                            _passwordController.text),
                      ),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      optionRow("Don't have an account? ", "Signup", context,
                          SignupScreen()),
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

  Future signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        debugPrint("Logged in!");
        setState(() {
          showIncorrectCredentials = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafeArea(child: Navigation()),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error signing in $e");
      setState(() {
        showIncorrectCredentials = true;
      });
    }
  }
}
