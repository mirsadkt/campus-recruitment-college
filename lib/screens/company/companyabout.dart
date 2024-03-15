// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyAbout extends StatefulWidget {
  const CompanyAbout({Key? key}) : super(key: key);

  @override
  State<CompanyAbout> createState() => _CompanyAboutState();
}

class _CompanyAboutState extends State<CompanyAbout> {
  late User _user;
  List<String> _about = [];

  Future<void> _getUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('companies')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();

          if (data != null) {
            setState(() {
              _user = user;

              if (data['about'] is String) {
                _about = [data['about']];
              } else {
                _about = (data['about'] as List<dynamic>).cast<String>();
              }
            });
          } else {
            print('User data is null');
          }
        } else {
          print('Snapshot does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company About'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildAboutContent(),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          _about.isEmpty
              ? Center(
                  child: Text(
                    'No information available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _about.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white12.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _about[index],
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
