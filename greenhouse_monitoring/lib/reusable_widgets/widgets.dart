// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget reusableButton(double buttonHeight, textFormFieldWith, String buttonName,
    VoidCallback onPressed) {
  return Container(
    height: buttonHeight,
    width: textFormFieldWith,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Color.fromRGBO(203, 166, 79, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(width: 2.0, color: Colors.black),
        ),
      ),
      child: Text(
        buttonName,
        style: GoogleFonts.robotoMono(
          color: Colors.black,
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget indicatorWidget(screenHeight, screenWidth) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Colors.green,
                height: screenHeight * 0.02,
                width: screenWidth * 0.04,
              ),
              SizedBox(
                width: screenWidth * 0.05,
              ),
              reusableText("Succesful Harvest", 11, Colors.black),
            ],
          ),
          Row(
            children: [
              Container(
                color: Colors.red,
                height: screenHeight * 0.02,
                width: screenWidth * 0.04,
              ),
              SizedBox(
                width: screenWidth * 0.05,
              ),
              reusableText("Failed Harvest", 11, Colors.black),
            ],
          )
        ],
      ),
    ),
  );
}

Widget pieChart(screenWidth, screenHeight, firstValue, secondValue) {
  return Container(
    width: screenWidth * 0.5,
    height: screenHeight * 0.1,
    child: PieChart(
      PieChartData(
        centerSpaceRadius: screenWidth * 0.1,
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            value: firstValue,
            color: Colors.red,
            radius: screenWidth * 0.2,
            titleStyle: GoogleFonts.robotoMono(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          PieChartSectionData(
            value: secondValue,
            color: Colors.green,
            radius: screenWidth * 0.2,
            titleStyle: GoogleFonts.robotoMono(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textField(
    double textFormFieldHeight,
    textFormFieldWith,
    String labelText,
    bool obscureText,
    TextEditingController textEditingController) {
  return Container(
    height: textFormFieldHeight,
    width: textFormFieldWith,
    child: TextFormField(
      controller: textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.all(16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide(width: 2.0),
        ),
      ),
    ),
  );
}

Widget optionRow(String initialText, navigationText, BuildContext context,
    Widget destinationScreen) {
  double fontSize = 11;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        initialText,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(fontSize: fontSize),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        ),
        child: Text(
          navigationText,
          style: GoogleFonts.robotoMono(
            textStyle: TextStyle(
                fontSize: fontSize, decoration: TextDecoration.underline),
          ),
        ),
      )
    ],
  );
}

Widget cardWidget(double width, height, IconData icon, String displayText) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon,
                size: 40,
                //r203, g166, b79
                color: Color.fromRGBO(203, 166, 79, 1)),
            SizedBox(width: 10),
            Text(displayText,
                style: GoogleFonts.robotoMono(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    ),
  );
}

Widget titleWidget(String titleName) {
  return Title(
      color: Color.fromRGBO(203, 166, 79, 1),
      child: Center(child: reusableText(titleName, 21, Colors.white)));
}

Widget reusableText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.robotoMono(
      textStyle: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
    ),
  );
}

Widget reusableSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

reusableNavItems(Icon icon, String label) {
  return BottomNavigationBarItem(
    icon: icon,
    label: label,
  );
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
      ),
    );
  }
}

Widget graphContainer(double screenHeight, screenWidth, Widget widget) {
  return Container(
    height: screenHeight * 0.4,
    width: screenWidth * 0.9,
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
    child: widget,
  );
}

Widget barChartWidget() {
  return Padding(
    padding: EdgeInsets.only(right: 18, top: 20),
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles:
                SideTitles(interval: 10, showTitles: true, reservedSize: 40),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
        ),
        barGroups: [
          barData(40, 1),
          barData(30, 2),
          barData(25, 3),
          barData(35, 4),
          barData(33, 5),
          barData(55, 6),
          barData(24, 7),
        ],
      ),
    ),
  );
}

BarChartGroupData barData(double toY, int day) {
  return BarChartGroupData(
    x: day,
    barRods: [
      BarChartRodData(fromY: 0, toY: toY, width: 15),
    ],
  );
}

Widget sensorContainer(double screenHeight, screenWidth, String parameterName,
    parameterValue, parameterUnit, IconData parameterIcon) {
  return Container(
    width: screenWidth * 0.42,
    height: screenHeight * 0.25,
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
    child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Icon(
            parameterIcon,
            size: screenWidth * 0.2,
          ),
          Text(
            parameterName,
            style: GoogleFonts.robotoMono(
              fontSize: screenWidth * 0.027,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                parameterValue,
                style: GoogleFonts.robotoMono(
                  fontSize: screenWidth * 0.11,
                ),
              ),
              Text(
                parameterUnit,
                style: GoogleFonts.robotoMono(
                  fontSize: screenWidth * 0.03,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
