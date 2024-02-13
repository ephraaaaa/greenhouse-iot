// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse_monitoring/reusable_widgets/widgets.dart';
import 'package:greenhouse_monitoring/screens/signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _user;
  late TextEditingController _displayNameController;
  late TextEditingController _displayAddressController;
  late TextEditingController _displayBusinessController;
  late TextEditingController _displayFailedHarvestCrops;
  late TextEditingController _displaySuccessfulHarvestCrops;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _displayNameController = TextEditingController();
    _displayAddressController = TextEditingController();
    _displayBusinessController = TextEditingController();
    _displayFailedHarvestCrops = TextEditingController();
    _displaySuccessfulHarvestCrops = TextEditingController();
  }

  Future<void> _initializeUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_user!.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _displayNameController.text = userData['displayName'] ?? 'No data';
        _displayAddressController.text =
            userData['displayAddress'] ?? 'No data';
        _displayBusinessController.text =
            userData['displayBusiness'] ?? 'No data';
        _displayFailedHarvestCrops.text =
            userData['displayFailedHarvest'] ?? 'No data';
        _displaySuccessfulHarvestCrops.text =
            userData['displaySuccessfulHarvest'] ?? 'No data';
      });
    }
  }

  Future<void> _updateUserProfile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(_user!.uid).set({
      'displayName': _displayNameController.text,
      'displayAddress': _displayAddressController.text,
      'displayBusiness': _displayBusinessController.text
    }, SetOptions(merge: true));
  }

  Future<void> _updateUserHarvest() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(_user!.uid).set({
      'displayFailedHarvest': _displayFailedHarvestCrops.text,
      'displaySuccessfulHarvest': _displaySuccessfulHarvestCrops.text,
    }, SetOptions(merge: true));
  }

  void _inputHarvest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _displayFailedHarvestCrops,
                decoration: InputDecoration(
                    labelText: 'Failed harvest crops(in kilos)'),
              ),
              TextField(
                controller: _displaySuccessfulHarvestCrops,
                decoration: InputDecoration(
                    labelText: 'Successful harvest crops(in kilos)'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateUserHarvest();
                _loadUserProfile();
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _displayAddressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: _displayBusinessController,
                decoration: InputDecoration(labelText: 'Business'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateUserProfile();
                _loadUserProfile();
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double textFormFieldWith = screenWidth * 0.7;

    double buttonHeight = screenHeight * 0.05;

//Yellow - r203, g166, b79
//Screen - r245, g240, b229
//Container - r246, g239, b 223

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(245, 240, 229, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: titleWidget("Profile"),
            ),
            backgroundColor: const Color.fromRGBO(203, 166, 79, 1),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: _signOut,
              )
            ],
          ),
        ),
        body: _user != null
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: screenWidth * 0.25,
                        backgroundImage: NetworkImage(_user!.photoURL ??
                            'https://e7.pngegg.com/pngimages/684/352/png-clipart-one-punch-man-saitama-anime-superhero-one-punch-child-face.png'),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        _displayNameController.text,
                        style: GoogleFonts.robotoMono(
                            fontSize: screenWidth * 0.1,
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        'Email: ${_user!.email}',
                        style: GoogleFonts.robotoMono(
                          color: Colors.grey,
                          textStyle: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      cardWidget(screenWidth * 0.7, screenHeight * 0.06,
                          Icons.house, _displayAddressController.text),
                      cardWidget(screenWidth * 0.7, screenHeight * 0.06,
                          Icons.business, _displayBusinessController.text),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      reusableButton(buttonHeight, textFormFieldWith,
                          "INPUT HARVEST", _inputHarvest),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: reusableButton(
                          buttonHeight,
                          textFormFieldWith,
                          "EDIT PROFILE",
                          _editProfile,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}


/*




 */