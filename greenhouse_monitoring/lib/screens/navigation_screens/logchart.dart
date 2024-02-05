// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/harvest_data.dart';

class LogChart extends StatefulWidget {
  const LogChart({super.key});

  @override
  State<LogChart> createState() => _LogChartState();
}

class _LogChartState extends State<LogChart> {
  late List<double> temperatureData;

  //Yellow - r203, g166, b79
  //Screen - r245, g240, b229
  //Container - r246, g239, b 223

  @override
  void initState() {
    super.initState();
    fetchTemperatureData();
  }

  void fetchTemperatureData() {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("weekly-broadcast").child("temperature");
    reference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        print(data);
        setState(() {
          temperatureData =
              List<double>.from(data.values.map((value) => value.toDouble()));
        });
      }
    }, onError: (Object error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(245, 240, 229, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            title: titleWidget("Logs"),
            backgroundColor: const Color.fromRGBO(203, 166, 79, 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Temperature (7D)",
                    style: GoogleFonts.robotoMono(fontSize: 20),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  graphContainer(screenHeight, screenWidth, barChartWidget()),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    "Humidity (7D)",
                    style: GoogleFonts.robotoMono(fontSize: 20),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  graphContainer(screenHeight, screenWidth, barChartWidget()),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    "Soil Moisture",
                    style: GoogleFonts.robotoMono(fontSize: 20),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  graphContainer(screenHeight, screenWidth, barChartWidget()),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    "Light Intensity (7D)",
                    style: GoogleFonts.robotoMono(fontSize: 20),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  graphContainer(screenHeight, screenWidth, barChartWidget()),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  reusableButton(
                    screenHeight * 0.05,
                    screenWidth * 0.7,
                    "Go to harvest",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HarvestPage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
