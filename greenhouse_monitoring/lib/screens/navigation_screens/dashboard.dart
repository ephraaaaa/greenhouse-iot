// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
//Yellow - r203, g166, b79
//Screen - r245, g240, b229
//Container - r246, g239, b 223

class _DashboardScreenState extends State<DashboardScreen> {
  late User? _user;
  String _greetingName = "";
  String _harvestCount = "";
  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return 'Good morning,';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _subscribeToRealtimeData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String weekName = DateFormat('EEEE').format(currentDate);
    String monthName = DateFormat('MMMM').format(currentDate);
    String day = (currentDate.day).toString();
    String year = (currentDate.year).toString();
    String dateText = '$monthName $day, $year\n$weekName';
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(245, 240, 229, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            title: titleWidget("Dashboard"),
            backgroundColor: const Color.fromRGBO(203, 166, 79, 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dateText,
                    style: GoogleFonts.robotoMono(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.07,
                        ),
                      ),
                      Text(
                        _greetingName,
                        style: GoogleFonts.robotoMono(
                          fontSize: screenWidth * 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "No. of harvest this month: ",
                      style:
                          GoogleFonts.robotoMono(fontSize: screenWidth * 0.03),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16)),
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.2,
                      child: Center(
                        child: Text(
                          _harvestCount,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "Rain: ",
                      style:
                          GoogleFonts.robotoMono(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.15,
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                height: screenHeight * 0.55,
                width: screenWidth * 0.95,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 235, 235),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sensorContainer(
                          screenHeight,
                          screenWidth,
                          "Temperature",
                          temperatureDisplay,
                          "°C",
                          Icons.thermostat,
                        ),
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                        sensorContainer(
                          screenHeight,
                          screenWidth,
                          "Humidity",
                          humidityDisplay,
                          "%",
                          Icons.heat_pump,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sensorContainer(
                          screenHeight,
                          screenWidth,
                          "Soil Moisture",
                          soilMoistureDisplay,
                          "%",
                          Icons.water,
                        ),
                        SizedBox(
                          width: screenWidth * 0.04,
                        ),
                        sensorContainer(
                          screenHeight,
                          screenWidth,
                          "Light Intensity",
                          lightIntensityDisplay,
                          "µmol/m²/s",
                          Icons.light,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserName() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_user!.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _greetingName = userData['displayName'] ?? '';
        _harvestCount = userData['displaySuccessfulHarvest'] ?? '';
      });
    }
  }

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

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _subscription;
  String temperatureDisplay = "";
  String humidityDisplay = "";
  String soilMoistureDisplay = "";
  String lightIntensityDisplay = "";

  void _subscribeToRealtimeData() {
    _subscription = _database.child('real-time').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        print(data);
        String temperature = data['temperature'].toString();
        String humidity = data['humidity'].toString();
        String soilMoisture = data['soil-moisture'].toString();
        String lightIntensity = data['light-intensity'].toString();

        setState(() {
          temperatureDisplay = temperature;
          lightIntensityDisplay = lightIntensity;
          soilMoistureDisplay = soilMoisture;
          humidityDisplay = humidity;
        });
      }
    });
  }
}
