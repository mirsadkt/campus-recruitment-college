// ignore_for_file: unused_field

import 'dart:async';

import 'package:campus_recruitment/screens/student/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({Key? key}) : super(key: key);

  @override
  _CompanySettingsPageState createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String companyname = '';
  String logoPic = '';
  bool isNotificationEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo();

    // Example of a timer that triggers setState
    // _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   _updateStateEverySecond();
    // });
  }

  Future _loadCompanyInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('companies')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          if (mounted) {
            companyname = snapshot['companyname'];
            logoPic = snapshot['userlogo'] ?? '';
          }
        }
      }
    } catch (e) {
      print("Error loading company information: $e");
    }
  }

  void _toggleNotification(bool value) {
    if (mounted) {
      setState(() {
        isNotificationEnabled = value;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _auth
          .signOut()
          .then((value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const StartPage(),
              ),
              (route) => false));
      // Navigator.pushReplacementNamed(context, '/onboardingScreen');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  void _navigateToFeedbackPage() {
    Navigator.pushNamed(context, '/feedbackpage');
  }

  // void _updateStateEverySecond() {
  //   if (mounted) {
  //     setState(() {
  //       // Your state update logic here
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   // Cancel the timer to avoid calling setState after the widget is disposed
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
          future: _loadCompanyInfo(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Account',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: logoPic == ''
                                  ? const AssetImage('assets/person.png')
                                  : NetworkImage(logoPic) as ImageProvider,
                            ),
                            title: Text(companyname),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'GENERAL',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.purpleAccent,
                        ),
                        title: const Text('Notification'),
                        trailing: Switch(
                          value: isNotificationEnabled,
                          onChanged: _toggleNotification,
                          activeColor: Colors.purpleAccent,
                        ),
                      ),
                      // ListTile(
                      //   leading: const Icon(
                      //     Icons.poll_rounded,
                      //     color: Colors.purpleAccent,
                      //   ),
                      //   title: const Text('Feedback'),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward,
                      //     color: Colors.grey,
                      //     size: 30,
                      //   ),
                      //   onTap: _navigateToFeedbackPage,
                      // ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.purpleAccent,
                        ),
                        title: const Text('Logout'),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onTap: () {
                          _logout();
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //       builder: (context) => const StartPage(),
                          //     ),
                          //     (route) => false);
                        },
                      ),
                    ],
                  );
          }),
    );
  }
}
