import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:greenhouse_monitoring/screens/navigation_screens/dashboard.dart';
import 'package:greenhouse_monitoring/screens/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCMf_3QMVYAdNPYQsV9e-vJDr2VrGjYyZU",
          appId: "1:1098012852802:android:5700614bcb1b412cd023db",
          messagingSenderId: "1098012852802",
          projectId: "green-house-monitoring-4f6c7",
          databaseURL:
              "https://green-house-monitoring-4f6c7-default-rtdb.asia-southeast1.firebasedatabase.app/"));
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SigninScreen(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
