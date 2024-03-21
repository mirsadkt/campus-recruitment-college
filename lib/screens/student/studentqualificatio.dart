// ignore_for_file: unused_field, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentQualification extends StatefulWidget {
  const StudentQualification({super.key});

  @override
  State<StudentQualification> createState() => _StudentQualificationState();
}

class _StudentQualificationState extends State<StudentQualification> {
  late User _user;
  List<String> _qualification = [];

  Future<void> _getUserDetails() async {
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

          if (data != null) {
            setState(() {
              _user = user;

              // Check if 'qualification' is a String, convert it to a List
              if (data['qualification'] is String) {
                _qualification = [
                  data['qualification']
                ]; // Convert to List with a single element
              } else {
                // If 'skills' is already a List, cast it
                _qualification =
                    (data['qualification'] as List<dynamic>).cast<String>();
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
        title: Text('View qualification',
        style: GoogleFonts.poppins(
          fontWeight:FontWeight.w400
        ),),
      ),
      body: _buildSkillsList(),
    );
  }

  Widget _buildSkillsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: _qualification.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _qualification[index],
              style: GoogleFonts.poppins(
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
            leading: Icon(
              Icons.fiber_manual_record,
              size: 20,
            ),
          );
        },
      ),
    );
  }
}
