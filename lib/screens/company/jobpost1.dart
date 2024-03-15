import 'package:campus_recruitment/screens/company/jobpost2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Jobpost1 extends StatefulWidget {
  const Jobpost1({Key? key}) : super(key: key);

  @override
  _Jobpost1State createState() => _Jobpost1State();
}

class _Jobpost1State extends State<Jobpost1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? dropdownValue = "Select";
  var positions = ["Select", "Writer", "Developer", "Tester", "Programmer"];

  String? dropdownValues = "Select";
  var categories = [
    "Select",
    "Full time",
    "Part time",
    "Internship",
    "Freelance"
  ];

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController positionController = TextEditingController();
final _formkey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 70.0, right: 210),
                  child: Text(
                    "Job Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 70.0, right: 210),
                  child: Text(
                    "Job Title",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return "The field is required";
                      }else {
                        return null;
                      }
                    },
                    controller: jobTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Job title",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Position",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return "The field is required";
                      }else {
                        return null;
                      }
                    },
                    controller: positionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Position",
                    ),
                  ),
                ),
                // TextFormField(
                //   controller: positionController,
                //    decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       hintText: dropdownValue,
                //     ),

                // ),
                // DropdownButtonFormField<String>(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   icon: const Icon(Icons.keyboard_arrow_down_sharp),
                //   value: dropdownValue,
                //   items: positions
                //       .map((String position) => DropdownMenuItem<String>(
                //             value: position,
                //             child: Text(position),
                //           ))
                //       .toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       dropdownValue = newValue;
                //     });
                //   },
                // ),
                const Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
               
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return "The field is required";
                      }else {
                        return null;
                      }
                    },
                    controller: categoryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Category",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                   validator: (value) {
                      if(value!.isEmpty){
                        return "The field is required";
                      }else {
                        return null;
                      }
                    },
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: ("Add description"),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () async {
                    if(_formkey.currentState!.validate()){
                      User? user = _auth.currentUser;
                    if (user != null) {
                      // Fetch the company details based on the user ID
                      DocumentSnapshot companySnapshot = await _firestore
                          .collection('companies')
                          .doc(user.uid)
                          .get();
            
                      // Check if the company details exist
                      if (companySnapshot.exists) {
                        // Retrieve the company name
                        Map<String, dynamic>? companyData =
                            companySnapshot.data() as Map<String, dynamic>?;
            
                        if (companyData != null) {
                          String companyname =
                              companyData['companyname'] ?? 'Unknown Company';
                          String address =
                              companyData['address'] ?? 'Unknown Company';
                          String email =
                              companyData['email'] ?? 'Unknown Company';
                          String contact =
                              companyData['contact'] ?? 'Unknown Company';
                          String website =
                              companyData['website'] ?? 'Unknown Company';
            
                          // Prepare job data
                          Map<String, dynamic> jobData = {
                            'companyId': user.uid, // Use user ID as company ID
                            'companyname': companyname,
                            'address': address,
                            'email': email,
                            'contact': contact,
                            'website': website,
                            'jobTitle': jobTitleController.text,
                            'position': positionController.text,
                            'category': categoryController.text,
                            'description': descriptionController.text,
                            // Add more fields as needed
                          };
            
                          // Store job data in Firestore
                          DocumentReference docRef =
                              await _firestore.collection('jobs').add(jobData);
            
                          // Navigate to the next screen with the document ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Jobpost2(docRef.id),
                            ),
                          );
                        } else {
                          print(
                              'Company details not found for user ID: ${user.uid}');
                        }
                      }
                    }


                    }
                    // Get the currently logged-in user
                                      },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
