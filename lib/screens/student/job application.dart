// ignore_for_file: unused_import, file_names, use_build_context_synchronously

import 'dart:io';

import 'package:campus_recruitment/screens/student/appliedjobs.dart';
import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class JobApplication extends StatefulWidget {
  final String userId;
  final String address;
  final String jobTitle;
  final String companyname;
  final String userName;
  final String userEmail;
  final String userNumber;
  final String userDOB;
  final String userQualification;
  final String userGender;
  final String userSkills;
  final String cgpa;
  final String? proPicUrl;

  const JobApplication({
    Key? key,
    required this.userId,
    required this.address,
    required this.jobTitle,
    required this.companyname,
    required this.userName,
    required this.userEmail,
    required this.userNumber,
    required this.userDOB,
    required this.userQualification,
    required this.userGender,
    required this.userSkills,
    required this.cgpa,
     this.proPicUrl,
  }) : super(key: key);

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  File? resumeFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String dob = '';
  String phone = '';
  String gender = '';
  String qualification = '';
  String resume = '';
  String skills = '';
  String status = 'Pending';

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        resumeFile = File(result.files.single.path ?? "");
      });
    }
  }

  Future<void> submitApplication() async {
    String jobName = widget.jobTitle;
    String jobAddress = widget.address;
    String jobTitle = widget.jobTitle;
    String username = fullNameController.text;
    String email = emailController.text;

    if (_formKey.currentState!.validate()) {
      if (resumeFile != null) {
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('resumes/$username ${DateTime.now().toString()}');
        await storageReference.putFile(resumeFile!, metadata);
        String resumeUrl = await storageReference.getDownloadURL();
        resume = resumeUrl;

        var firestore = FirebaseFirestore.instance;
        await firestore.collection('applied_jobs').add({
          'userId': widget.userId,
          'jobName': jobName,
          'jobAddress': jobAddress,
          'jobTitle': jobTitle,
          'companyname': widget.companyname,
          'username': username,
          'email': email,
          'dob': widget.userDOB,
          'phone': widget.userNumber,
          'gender': widget.userGender,
          'cgpa': widget.cgpa,
          'qualification': widget.userQualification,
          'resume': resume,
          'skills': widget.userSkills,
          'status': status,
          'profilePicUrl': widget.proPicUrl,
          // Add other fields as needed
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Congratulations',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        'Your application has been submitted successfully'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                const StudentBottomNavigation(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Home'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );

        // Store resumeUrl in Firestore or use it as needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Apply for Job',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Full Name'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The Field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your full name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Email'),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The Field is required";
                    } else if (!(value.contains("@gmail.com"))) {
                      return "email not valid";
                    } else {
                      return null;
                    }
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: ListTile(
                            title: Text(
                              resumeFile != null
                                  ? resumeFile!.path
                                      .split('/')
                                      .last // Extract only the file name
                                  : 'No file selected',
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: pickResume,
                              icon: const Icon(Icons.attach_file),
                              label: const Text('Upload File'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Description'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The Field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Enter your description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
