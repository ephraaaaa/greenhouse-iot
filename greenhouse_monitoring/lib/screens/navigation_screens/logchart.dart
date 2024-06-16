// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/data_archive.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/harvest_data.dart';
import 'package:http/http.dart' as http;

class LogChart extends StatefulWidget {
  const LogChart({super.key});

  @override
  State<LogChart> createState() => _LogChartState();
}

class _LogChartState extends State<LogChart> {
  List<double> temperatures = [];
  List<double> humidities = [];
  List<double> soilMoisture = [];
  List<double> lightIntensity = [];
  //Yellow - r203, g166, b79
  //Screen - r245, g240, b229
  //Container - r246, g239, b 223

  @override
  void initState() {
    super.initState();
    fetchTemperatureData();
  }

  void fetchTemperatureData() async {
    try {
      final response = await http.get(
        Uri.parse('https://greenhousemonitoring.site/server/weekly_broadcast'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List<dynamic>) {
          final List<Map<String, dynamic>> weeklyBroadcast =
              List<Map<String, dynamic>>.from(data);
          // Get temperature value for a specific day (e.g., day 2)
          print(weeklyBroadcast);
          for (int i = 0; i < weeklyBroadcast.length; i++) {
            int temperatureOfDay = weeklyBroadcast[i]['temperature'];
            temperatures.add(temperatureOfDay.toDouble());
            int humidityOfDay = weeklyBroadcast[i]['humidity'];
            humidities.add(humidityOfDay.toDouble());
            int soilMoistureOfDay = weeklyBroadcast[i]['soil-moisture'];
            soilMoisture.add(soilMoistureOfDay.toDouble());
            int lightIntensityOfDay = weeklyBroadcast[i]['light-intensity'];
            lightIntensity.add(lightIntensityOfDay.toDouble());
          }
          if (temperatures.isEmpty && humidities.isEmpty) {
            print("No data");
          } else {
            setState(() {});
            print(temperatures);
            print(humidities);
            print(soilMoisture);
            print(lightIntensity);
          }
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
                  graphContainer(
                    screenHeight,
                    screenWidth,
                    barChartWidget(temperatures),
                  ),
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
                  graphContainer(
                      screenHeight, screenWidth, barChartWidget(humidities)),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
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
                  graphContainer(
                      screenHeight, screenWidth, barChartWidget(soilMoisture)),
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
                  graphContainer(screenHeight, screenWidth,
                      barChartWidget(lightIntensity)),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Row(
                    children: [
                      reusableButton(
                        screenHeight * 0.05,
                        screenWidth * 0.35,
                        "Harvest",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HarvestPage()),
                          );
                        },
                      ),
                      reusableButton(
                        screenHeight * 0.05,
                        screenWidth * 0.35,
                        "Data archive",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataArchive()),
                          );
                        },
                      ),
                    ],
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
