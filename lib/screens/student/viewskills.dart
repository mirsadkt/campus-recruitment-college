// ignore_for_file: unused_field, prefer_const_constructors, avoid_print, library_private_types_in_public_api

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewSkill extends StatefulWidget {
  const ViewSkill({super.key});

  @override
  _ViewSkillState createState() => _ViewSkillState();
}

class _ViewSkillState extends State<ViewSkill> {
  late User _user;
  List<String> _skills = [];

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

              // Check if 'skills' is a String, convert it to a List
              if (data['skill'] is String) {
                _skills = [
                  data['skill']
                ]; // Convert to List with a single element
              } else {
                // If 'skills' is already a List, cast it
                _skills = (data['skill'] as List<dynamic>).cast<String>();
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
        title: Text('View Skills',
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
        itemCount: _skills.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _skills[index],
              style: GoogleFonts.poppins(
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
            leading: const Icon(
              Icons.fiber_manual_record,
              size: 20,
            ),
          );
        },
      ),
    );
  }
}
