// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

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
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      reusableText("This Month", 15, Colors.black),
                      SizedBox(
                        height: screenHeight * 0.15,
                      ),
                      pieChart(screenWidth, screenHeight, 34.5, 65.5),
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
                                spots: const [
                                  FlSpot(1, 120),
                                  FlSpot(2, 300),
                                  FlSpot(3, 120),
                                  FlSpot(4, 90),
                                  FlSpot(5, 110),
                                  FlSpot(6, 150),
                                  FlSpot(7, 140),
                                  FlSpot(8, 220),
                                  FlSpot(9, 120),
                                  FlSpot(10, 320),
                                  FlSpot(11, 420),
                                  FlSpot(12, 320),
                                ],
                                isCurved: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(.6),
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
                reusableButton(
                  screenHeight * 0.05,
                  screenWidth * 0.7,
                  "Go back",
                  () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
