import 'package:campus_recruitment/screens/student/studentlogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tellusstudent extends StatefulWidget {
  const Tellusstudent({super.key});

  @override
  _TellusstudentState createState() => _TellusstudentState();
}

class _TellusstudentState extends State<Tellusstudent> {
  TextEditingController livecontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController qualificationcontroller = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  TextEditingController skillcontroller = TextEditingController();
  TextEditingController pincodecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: Text(
                          "Tell us about yourself",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: gendercontroller,
                          decoration: const InputDecoration(
                            hintText: "Gender",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Gender';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: livecontroller,
                          decoration: const InputDecoration(
                            hintText: "Where do you live?",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter where you live';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          maxLength: 3,
                          controller: cgpaController,
                          decoration: const InputDecoration(
                            hintText: "CGPA",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your year of Experience';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: qualificationcontroller,
                          decoration: const InputDecoration(
                            hintText: "Qualification",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Qualification';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: skillcontroller,
                          decoration: const InputDecoration(
                            hintText: "Skill",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Skill';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          maxLength: 6,
                          controller: pincodecontroller,
                          decoration: const InputDecoration(
                            hintText: "Pincode",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your pincode';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    await saveDataToFirestore();
                    _showSuccessMessage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentLogIn()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  "Proceed",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 15.0,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     _showSkipConfirmationDialog();
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.all(25.0),
              //     child: Center(
              //       child: Text(
              //         " Skip for now",
              //         style: TextStyle(
              //           color: Colors.blue,
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveDataToFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Check if the document already exists
        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          // Update the existing document
          await userDocRef.update({
            'gender': gendercontroller.text,
            'live': livecontroller.text,
            'CGPA': cgpaController.text,
            'qualification': qualificationcontroller.text,
            'skill': skillcontroller.text,
            'pincode': pincodecontroller.text,
            'field': null,
          });
        } else {
          // Create a new document if it doesn't exist
          await userDocRef.set({
            'gender': gendercontroller.text,
            'live': livecontroller.text,
            'CGPA': cgpaController.text,
            'qualification': qualificationcontroller.text,
            'skill': skillcontroller.text,
            'pincode': pincodecontroller.text,
          });
        }
      }
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  void _showSkipConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are You Sure?"),
          content: const Text("You can fill in later at the profile Section"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Proceed Anyway"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Details added successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
