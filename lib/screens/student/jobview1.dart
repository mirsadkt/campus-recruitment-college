// ignore_for_file: avoid_print, unnecessary_cast, unused_local_variable, prefer_const_constructors

import 'package:campus_recruitment/screens/student/job%20application.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobDetails {
  final String companyId;
  final String companyname;
  final String jobTitle;
  final String jobType;
  final String position;
  final String category;
  final String expectedSkills;
  final String description;
  final String currentSalary;
  final bool immediatStart;
  final List<String> workDays;

  JobDetails({
    required this.companyId,
    required this.companyname,
    required this.jobTitle,
    required this.jobType,
    required this.position,
    required this.category,
    required this.expectedSkills,
    required this.description,
    required this.currentSalary,
    required this.immediatStart,
    required this.workDays,
  });
}

class JObview1 extends StatefulWidget {
  final JobDetails jobDetails;

  const JObview1({required this.jobDetails, Key? key}) : super(key: key);

  @override
  State<JObview1> createState() => _JObview1State();
}

class _JObview1State extends State<JObview1> {
  String? description;
  String? expectedSkills;
  String? maxSalary;
  String? minSalary;
  String? about;
  String? phone;
  String? email;
  String? website;
  bool immediateStart = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future fetchDataFromFirebase() async {
    try {
      print(immediateStart);
      var snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('companyname', isEqualTo: widget.jobDetails.companyname).where('jobTitle',isEqualTo: widget.jobDetails.jobTitle,)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs[0].data() as Map<String, dynamic>;
        print('///////////$data');

        // Ensure that the required fields exist in the document
        if (data.containsKey('description') &&
            data.containsKey('expectedSkills') &&
            data.containsKey('expectedSalary')&&
            data.containsKey('currentSalary')&&
            data.containsKey('immediateStart')&&
            data.containsKey('website')) {
          description = data['description'] ?? 'N/A';
          maxSalary = data['expectedSalary'] ?? 'N/A';
          minSalary = data['currentSalary'] ?? 'N/A';
          immediateStart = data['immediateStart'] ?? 'N/A';
          website = data['website'] ?? 'N/A';

          // Check the type of 'expectedSkills' and convert if necessary
          if (data['expectedSkills'] is List<dynamic>) {
            expectedSkills = (data['expectedSkills'] as List<dynamic>)
                .cast<String>()
                .join(', ');
          } else {
            expectedSkills = data['expectedSkills'] ?? 'N/A';
          }
        } else {
          print('Required fields do not exist in the document');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e\n$stackTrace');
    }
  }

  String userid = '';
  String userName = '';
  String userEmail = '';
  String userDOB = '';
  String userGender = '';
  String userQualification = '';
  String userSkills = '';
  String userNumber = '';
  String cgpa = '';
  String proPicUrl = '';
  Future fetchUsers() async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot snapshot = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        userid = snapshot.id;
        userName = snapshot['username'];
        userEmail = snapshot['email'];
        userDOB = snapshot['dob'];
        userGender = snapshot['gender'];
        userQualification = snapshot['qualification'];
        userSkills = snapshot['skill'];
        userNumber = snapshot['phoneNumber'];
        cgpa = snapshot['CGPA'];
        proPicUrl = snapshot['profilePicUrl'];
      }

      print(userName);
      print(userEmail);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: FutureBuilder(
            future: fetchDataFromFirebase().then((value) => fetchUsers()),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Background Image
                              SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: const Image(
                                  image: AssetImage('assets/bg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Company Logo
                              const Padding(
                                padding: EdgeInsets.only(left: 150, top: 100),
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/Company-Vectors .png'),
                                  radius: 45,
                                ),
                              ),
                              // Back Button
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Navigate back
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_backspace_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    widget.jobDetails.jobTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    widget.jobDetails.companyname,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const TabBar(
                                    isScrollable:
                                        true, // Set this property to true
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: [
                                      Tab(text: 'Description'),
                                      Tab(text: 'Contact'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Description Tab

                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Job Description: $description',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Skills: $expectedSkills',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Min Salary: $minSalary',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Max Salary: $maxSalary',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                       immediateStart == true?const Text(
                                          'Looking for immediate joiners',
                                          style:  TextStyle(fontSize: 16),
                                        ):const Text(''),

                                        const SizedBox(height: 10),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobApplication(
                                                    userId: userid,
                                                    address: '',
                                                    jobTitle: widget
                                                        .jobDetails.jobTitle,
                                                    companyname: widget
                                                        .jobDetails.companyname,
                                                    userName: userName,
                                                    userEmail: userEmail,
                                                    userNumber: userNumber,
                                                    userDOB: userDOB,
                                                    userQualification:
                                                        userQualification,
                                                    userGender: userGender,
                                                    userSkills: userSkills,
                                                    cgpa: cgpa,
                                                    proPicUrl: proPicUrl,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              // primary: Colors.blue,
                                              // onPrimary: Colors.white,
                                            ),
                                            child: const Text('Apply Job'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Company Tab
                                FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection(
                                          'companies') // Use 'companies' collection instead of 'jobs'
                                      .doc(widget.jobDetails.companyId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    if (snapshot.data == null ||
                                        !snapshot.data!.exists) {
                                      return Text('Document does not exist');
                                    }

                                    var companyData = snapshot.data!.data()
                                        as Map<String, dynamic>;

                                    // setState(() {
                                    //   about = companyData['about'] ?? 'N/A';
                                    // });

                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              'Phone: ${snapshot.data!['phoneNo']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Email: ${snapshot.data!['email']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Website: ${snapshot.data!['website'] == null ||snapshot.data!['website'] == "" ? "Not Available":snapshot.data!['website']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Industry: ${snapshot.data!['industry'] == null ||snapshot.data!['industry'] ==""  ? "Not Available":snapshot.data!['industry']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'About: ${snapshot.data!['about'] == null || snapshot.data!['about'] == ""? "Not Available":snapshot.data!['about']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
