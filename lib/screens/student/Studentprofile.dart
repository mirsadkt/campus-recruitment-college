// ignore_for_file: unused_import, unused_field

import 'package:campus_recruitment/screens/student/appliedjobs.dart';
import 'package:campus_recruitment/screens/student/personaldetails.dart';
import 'package:campus_recruitment/screens/student/start.dart';
import 'package:campus_recruitment/screens/student/student%20profile2.dart';
import 'package:campus_recruitment/screens/student/studentqualificatio.dart';
import 'package:campus_recruitment/screens/student/studentviewresume.dart';
import 'package:campus_recruitment/screens/student/viewskills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String? _name;
  String? _field;
  String? _email;
  String? resumeUrl;
  String? proPicUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();

          if (data != null && data.containsKey('name')) {
            _name = data['name'] ?? 'Unknown';
            _field = data['field'] ?? 'Unknown';
            _email = data['email'] ?? 'Unknown';
            resumeUrl = data["resumeUrl"] ?? "Unknown";
            proPicUrl = data["profilePicUrl"] ?? "Unknown";
          } else {
            print('Name field not found in the snapshot');
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            print('///////$proPicUrl');
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 190),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white38,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const StudentProfile2(),
                                          ),
                                        ).then((result) {
                                          if (result != null) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 380),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 635,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the next page when the card is tapped
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PersonalDetails(),
                                        ),
                                      );
                                    },
                                    child: const Card(
                                      color: Color(0xFFD3D3D3),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.star_outline_outlined,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Personal Details',
                                          textScaleFactor: 1.5,
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the next page when the card is tapped
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const StudentQualification(),
                                        ),
                                      );
                                    },
                                    child: const Card(
                                      color: Color(0xFFD3D3D3),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.shopping_bag_rounded,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Qualification',
                                          textScaleFactor: 1.5,
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ViewSkill(),
                                        ),
                                      );
                                    },
                                    child: const Card(
                                      color: Color(0xFFD3D3D3),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.pie_chart,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Skills',
                                          textScaleFactor: 1.5,
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     print(resumeUrl);
                                  //     print(
                                  //         "----------------------------------");
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             StudentViewResume(
                                  //           resumeUrl: "${resumeUrl}",
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  //   child: const Card(
                                  //     color: Color(0xFFD3D3D3),
                                  //     child: ListTile(
                                  //       leading: Icon(
                                  //           Icons.contact_page_outlined,
                                  //           color: Colors.blue),
                                  //       title: Text(
                                  //         'Resume',
                                  //         textScaleFactor: 1.5,
                                  //       ),
                                  //       trailing: Icon(
                                  //         Icons.keyboard_arrow_right,
                                  //         color: Colors.blue,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // View Applied jobs Card
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AppliedJobs(),
                                        ),
                                      );
                                    },
                                    child: const Card(
                                      color: Color(0xFFD3D3D3),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.compass_calibration_outlined,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'View Applied jobs',
                                          textScaleFactor: 1.5,
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      _logout(context);
                                    },
                                    child: const Card(
                                      color: Color(0xFFD3D3D3),
                                      child: ListTile(
                                        leading: Icon(Icons.logout,
                                            color: Colors.blue, size: 30),
                                        title: Text(
                                          "Logout",
                                          textScaleFactor: 1.5,
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 180, left: 12),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              // height: 200,
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: proPicUrl == null
                                          ? const AssetImage(
                                              'assets/person.png')
                                          : NetworkImage(proPicUrl!)
                                              as ImageProvider, // You can replace this with your actual image
                                      radius: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _name ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _field ?? 'Job Field Not Specified',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(_email ?? 'Unknown'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> _logout(context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const StartPage(),
          ),
          (route) => false);
    } catch (e) {
      print("Error during logout: $e");
    }
  }
}
