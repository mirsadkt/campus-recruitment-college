// ignore_for_file: unused_import, prefer_final_fields, avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:campus_recruitment/screens/student/Studentprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfile2 extends StatefulWidget {
  const StudentProfile2({super.key});

  @override
  State<StudentProfile2> createState() => _StudentProfile2State();
}

class _StudentProfile2State extends State<StudentProfile2> {
  ImagePicker picker = ImagePicker();
  File? pickedImage;
  File? resumeFile;
  User? _user;
  TextEditingController _name = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _field = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _cgpa = TextEditingController();
  TextEditingController _qualification = TextEditingController();
  TextEditingController _skills = TextEditingController();

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
            _user = user;
            _name.text = data['name'] ?? '';
            _lastName.text = data['lastName'] ?? '';
            _email.text = data['email'] ?? '';
            _field.text = data['field'] ?? '';
            _dob.text = data['dob'] ?? '';
            _phoneNumber.text = data['phoneNumber'] ?? '';
            _gender.text = data['gender'] ?? '';
            _cgpa.text = data['CGPA'] ?? '';
            _qualification.text = data['qualification'] ?? '';
            _skills.text = data['skill'] ?? '';
          } else {
            print('User data not found in the snapshot');
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserDetails() async {
    try {
      if (pickedImage != null) {
        // Upload profile picture to Firebase Storage
        String profilePicUrl = await _uploadFile(pickedImage!, 'profile_pics');
        print(profilePicUrl);
        print("==================================================");
        _updateUserProfilePic(profilePicUrl);
      }

      if (resumeFile != null) {
        // Upload resume to Firebase Storage
        String resumeUrl = await _uploadFile(resumeFile!, 'resumes');
        _updateUserResume(resumeUrl);
      }

      // Update other user details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({
        'name': _name.text,
        'lastName': _lastName.text,
        'email': _email.text,
        'field': _field.text,
        'dob': _dob.text,
        'phoneNumber': _phoneNumber.text,
        'gender': _gender.text,
        'CGPA': _cgpa.text,
        'qualification': _qualification.text,
        'skill': _skills.text,
      });
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  String? proPic;
  Future<String> _uploadFile(File file, String storageFolder) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      Reference storageReference =
          FirebaseStorage.instance.ref().child('$storageFolder/$fileName');
      UploadTask uploadTask = storageReference.putFile(file, metadata);
      await uploadTask.whenComplete(() => null);

      String downloadUrl = await storageReference.getDownloadURL();
      proPic = downloadUrl;
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('File upload failed');
    }
  }

  void _updateUserProfilePic(String profilePicUrl) {
    FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
      'profilePicUrl': profilePicUrl,
    });
  }

  void _updateUserResume(String resumeUrl) {
    FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
      'resumeUrl': resumeUrl,
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      setState(() {
        resumeFile = file;
      });
    }
  }

  OutlineInputBorder _customBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(width: 0.5, color: Colors.black),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                           
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: pickedImage != null
                                        ? ClipOval(
                                            child: Image.file(
                                              pickedImage!,
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    // initialValue: _name.text,
                                    controller: _name,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      border: _customBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    // initialValue: _lastName.text,
                                    controller: _lastName,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      border: _customBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _email.text,
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _field.text,
                              controller: _field,
                              decoration: InputDecoration(
                                labelText: 'position',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _dob.text,
                              controller: _dob,
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _phoneNumber.text,
                              controller: _phoneNumber,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _gender.text,
                              controller: _gender,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _cgpa.text,
                              controller: _cgpa,
                              decoration: InputDecoration(
                                labelText: 'CGPA',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // initialValue: _qualification.text,
                              controller: _qualification,
                              decoration: InputDecoration(
                                labelText: 'Qualification',
                                border: _customBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    // initialValue: _skills.text,
                                    controller: _skills,
                                    decoration: InputDecoration(
                                      labelText: 'Skills',
                                      border: _customBorder(),
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 16),
                                // ElevatedButton.icon(
                                //   onPressed: () {
                                //     pickResume();
                                //   },
                                //   icon: const Icon(Icons.attach_file),
                                //   label: const Text('Add Resume'),
                                // ),
                              ],
                            ),
                      SizedBox(height: 20,width: 150,),
                            ElevatedButton(
                              onPressed: () async {
                                await _updateUserDetails();
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Done',
                              style: GoogleFonts.poppins(
                                fontWeight:FontWeight.w400,
                                fontSize:14,
                                color:Colors.black
                              ),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
