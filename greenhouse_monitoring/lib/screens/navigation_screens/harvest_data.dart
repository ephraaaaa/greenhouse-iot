// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';

class HarvestPage extends StatefulWidget {
  const HarvestPage({super.key});

  @override
  State<HarvestPage> createState() => _HarvestPageState();
}

int touchedIndex = -1;

class _HarvestPageState extends State<HarvestPage> {
  late User? _user;
  String _failedHarvestCount = "";
  String _successfulHarvestCount = "";
  double success = 0;
  double fail = 0;
  Future<void> _initializeUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        _user = user;
      });

      _loadUserName();
    }
  }

  Future<void> _loadUserName() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_user!.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      print("Userdata: $userData");
      setState(() {
        _successfulHarvestCount = userData['displaySuccessfulHarvest'] ?? '';
        _failedHarvestCount = userData['displayFailedHarvest'] ?? '';
        print("Success: $_successfulHarvestCount");
        print("Failed: $_failedHarvestCount");
        success = double.parse(_successfulHarvestCount);
        fail = double.parse(_failedHarvestCount);
      });
    } else {
      print("Could not fetch data");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    var random = Random();

    DateTime now = DateTime.now();
    int currentMonth = now.month;
    List<FlSpot> spots = [];

    for (int i = 0; i <= currentMonth; i++) {
      int randomNumber = random.nextInt(101);

      spots.add(
        FlSpot(i.toDouble(), (100 + randomNumber).toDouble()),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(245, 240, 229, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            title: titleWidget("Harvest Page"),
            backgroundColor: const Color.fromRGBO(203, 166, 79, 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                ),
                Container(
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Color.fromRGBO(230, 205, 148, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      reusableText("This Month", 15, Colors.black),
                      SizedBox(
                        height: screenHeight * 0.15,
                      ),
                      pieChart(screenWidth, screenHeight, fail, success),
                      SizedBox(
                        height: screenHeight * 0.15,
                      ),
                      indicatorWidget(screenHeight, screenWidth),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Container(
                  height: screenHeight * 0.5,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 2), // Offset in the x, y direction
                      ),
                    ],
                    color: Color.fromRGBO(230, 205, 148, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.45,
                        width: screenWidth * 0.85,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.green.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      reusableText("Successful Harvests in Previous Months", 10,
                          Colors.black)
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: reusableButton(
                    screenHeight * 0.05,
                    screenWidth * 0.7,
                    "Go back",
                    () {
                      Navigator.pop(context);
                    },
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
