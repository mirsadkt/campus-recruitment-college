// ignore_for_file: unused_import, avoid_print, prefer_const_constructors

import 'package:campus_recruitment/screens/student/first.dart';
import 'package:campus_recruitment/screens/student/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging, RemoteMessage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String name = ''; // Variable to hold the student name
  bool isNotificationEnabled = false;
  String? proPicUrl;

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
    _setupFirebaseMessaging();
  }

  Future<void> _loadStudentInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot usersSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (usersSnapshot.exists) {
          setState(() {
            name = usersSnapshot['name'];
            proPicUrl = usersSnapshot['profilePicUrl'];
          });

          print('Name: $name');
        } else {
          print('Document does not exist for user ${user.uid}');
        }
      } else {
        print('User is null');
      }
    } catch (e) {
      print("Error loading student information: $e");
    }
  }

  void _setupFirebaseMessaging() {
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Foreground Message Data: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("Opened App Message Data: ${message.data}");
    });
  }

  void _toggleNotification(bool value) {
    setState(() {
      isNotificationEnabled = value;

      // Subscribe/unsubscribe from FCM topic based on the toggle
      if (isNotificationEnabled) {
        _firebaseMessaging.subscribeToTopic('jobs');
      } else {
        _firebaseMessaging.unsubscribeFromTopic('jobs');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _loadStudentInfo(),
          builder: (context, snapshot) {
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100.0, left: 10),
                  child: Text(
                    "Settings",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 10, bottom: 15),
                  child: Text(
                    "Account",
                    style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(255, 211, 209, 209),
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 211, 209, 209),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: proPicUrl == null
                          ? const AssetImage('assets/person.png')
                          : NetworkImage(proPicUrl!) as ImageProvider,
                    ),
                    title: Text(name),
                    subtitle: Text(_auth.currentUser?.email ?? ''),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 13, bottom: 10),
                  child: Text(
                    "General",
                    style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: ListTile(
                    title: Text("Notification",
                    ),
                    leading: const Icon(Icons.notifications,
                        color: Colors.blue, size: 30),
                    trailing: Transform.scale(
                      scale: 1,
                      child: Switch(
                        value: isNotificationEnabled,
                        activeColor: Colors.blue,
                        inactiveTrackColor: Colors.white,
                        onChanged: _toggleNotification,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
