import 'dart:io';

import 'package:campus_recruitment/screens/company/CompanyEdit Profile.dart';
import 'package:campus_recruitment/screens/company/CompanyShowProfile.dart';
import 'package:campus_recruitment/screens/company/auth_service.dart';
import 'package:campus_recruitment/screens/company/companyabout.dart';
import 'package:campus_recruitment/screens/company/notificationpage.dart';
import 'package:campus_recruitment/screens/company/posted_jobs.dart';
import 'package:campus_recruitment/screens/company/viewshortlisted.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Company {
  final String companyname;
  final String email;
  final String logoUrl;

  Company({
    required this.companyname,
    required this.email,
    required this.logoUrl,
  });
}

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({Key? key}) : super(key: key);

  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final AuthService _authService = AuthService();
  User? _user;
  Company? _company;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _authService.authStateChanges.listen((User? user) {
      setState(() {
        _user = user;
        if (user != null) {
          // Fetch company details from Firestore
          _fetchCompanyDetails(user.uid);
        }
      });
    });
  }

  Future _fetchCompanyDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('companies')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        _company = Company(
            companyname: snapshot.get('companyname'),
            email: snapshot.get('email'),
            logoUrl: snapshot.get('userlogo') ?? '');
      }
    } catch (e) {
      print('Error fetching company details: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveImageToFirebase() async {
    try {
      if (_pickedImage != null) {
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        // Upload image to Firebase Storage
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('user_logos/${_user!.uid}');
        await storageRef.putFile(_pickedImage!, metadata);

        // Get the download URL
        final String downloadURL = await storageRef.getDownloadURL();

        // Update userlogo field in Firestore
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(_user!.uid)
            .update({'userlogo': downloadURL});

        // Show a success message or navigate to another page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: FutureBuilder(
          future: _fetchCompanyDetails(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.hasError
                    ? Center(
                        child: Text(snapshot.error.toString()),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Column(
                            children: [
                              // Center profile icon with image picker
                              GestureDetector(
                                onTap: () async {
                                  await _pickImage()
                                      .then((value) => _saveImageToFirebase());
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: _company!.logoUrl == ''
                                      ? const AssetImage('assets/person.png')
                                      : NetworkImage(_company!.logoUrl)
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 30),
                              if (_user != null)
                                Column(
                                  children: [
                                    Text(
                                      _company!.companyname,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(_company!.email),
                                  ],
                                )
                              else
                                const Text('Not logged in'),

                              // Buttons row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CompanyShowProfile()),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.purple),
                                    ),
                                    child: const Text(
                                      'Show Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CompanyEditProfile()),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.purple),
                                    ),
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),

                              // Cards section
                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.notifications),
                                  title: const Text('Notifications'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationPage()),
                                    );
                                  },
                                ),
                              ),

                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.info),
                                  title: const Text('About'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CompanyAbout()),
                                    );
                                  },
                                ),
                              ),

                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.short_text),
                                  title: const Text('Shortlist Candidate'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShortListCandidates(
                                                companyName:
                                                    _company!.companyname,
                                              )),
                                    );
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.work_history_outlined),
                                  title: const Text('Posted Jobs'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PostedJobs()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
          }),
    );
  }
}
