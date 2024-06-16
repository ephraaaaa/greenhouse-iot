import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DataArchive extends StatefulWidget {
  const DataArchive({super.key});

  @override
  State<DataArchive> createState() => _DataArchiveState();
}

class _DataArchiveState extends State<DataArchive> {
  var temperatureData = '';
  var humidityData = '';
  var soilMoistureData = '';
  var lightIntensityData = '';
  var totalHarvestData = '';

  DateTime? selectedDate;
  Map<String, dynamic>? documentData;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchDocumentData(picked);
        print("Selected Date: " + selectedDate.toString());
      });
    }
  }

  void fetchDocumentData(DateTime date) async {
    DateTime midnightDate = DateTime(date.year, date.month, date.day);
    int unixTimestamp = midnightDate.millisecondsSinceEpoch ~/ 1000;

    print("Timestamp: $unixTimestamp");

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('data_archive')
        .doc(unixTimestamp.toString())
        .get();
    if (documentSnapshot.exists) {
      setState(() {
        documentData = documentSnapshot.data() as Map<String, dynamic>;
        temperatureData = documentData?['temperature'].toString() ?? '';
        humidityData = documentData?['humidity'].toString() ?? '';
        soilMoistureData = documentData?['soil_moisture'].toString() ?? '';
        lightIntensityData = documentData?['light_intensity'].toString() ?? '';
        totalHarvestData = documentData?['total_harvest'].toString() ?? '';
        print(documentData);
      });
    } else {
      setState(() {
        print('No data to show');
        documentData = null;
        temperatureData = '';
        humidityData = '';
        soilMoistureData = '';
        lightIntensityData = '';
        totalHarvestData = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 240, 229, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          title: titleWidget("Data Archive"),
          backgroundColor: const Color.fromRGBO(203, 166, 79, 1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              selectedDate == null
                  ? 'No date selected!'
                  : 'Selected date: ${DateFormat('MM/dd/yyyy').format(selectedDate!)}',
              style: GoogleFonts.robotoMono(fontSize: 11),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(203, 166, 79, 1)),
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
                'Select date',
                style: GoogleFonts.robotoMono(fontSize: 8),
              ),
            ),
            const SizedBox(height: 20),
            documentData == null
                ? const Text('No data found for the selected date.')
                : Column(
                    children: [
                      Text(
                        "Data for the Selected Date:",
                        style: GoogleFonts.robotoMono(fontSize: 15),
                      ),
                      Text(
                        "Temperature: $temperatureData °C",
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                      Text(
                        "Humidity: $humidityData %",
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                      Text(
                        "Soil Moisture: $soilMoistureData %",
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                      Text(
                        "Light Intensity: $lightIntensityData lux",
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                      Text(
                        "Total Harvest: $totalHarvestData kg",
                        style: GoogleFonts.robotoMono(fontSize: 11),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
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
    );
  }
}
