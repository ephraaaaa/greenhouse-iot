// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/dashboard.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/logchart.dart';
import 'package:greenhouse_monitoring/screens/navigation_screens/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    LogChart(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(203, 166, 79, 1),
        //Yellow - r203, g166, b79
        //Screen - r245, g240, b229
        //
        items: [
          reusableNavItems(Icon(Icons.dashboard), "Dashboard"),
          reusableNavItems(Icon(Icons.auto_graph_rounded), "Logs"),
          reusableNavItems(Icon(Icons.person), "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapped,
      ),
    );
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
