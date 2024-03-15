// ignore_for_file: unused_import

import 'package:campus_recruitment/screens/company/Viewresume.dart';
import 'package:campus_recruitment/screens/company/notificationpage.dart';
import 'package:campus_recruitment/screens/company/view_resume.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> appliedJobs = [];

  String companyname = '';
  String status = '';

  Future<void> _loadCompanyInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot companySnapshot = await FirebaseFirestore.instance
            .collection('companies')
            .doc(user.uid)
            .get();

        if (companySnapshot.exists) {
          companyname = companySnapshot['companyname'];
        }
      }
    } catch (e) {
      print("Error loading company information: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _loadCompanyInfo(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.purpleAccent,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showSearch(
                                    context: context,
                                    delegate:
                                        StudentSearchDelegate(appliedJobs),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.purpleAccent,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 130),
                        child: Text(
                          'Recent Applicants',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 30),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('applied_jobs')
                              .where('companyname', isEqualTo: companyname).where('status',isEqualTo: 'Pending')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              print("Error: ${snapshot.error}");
                              return const Center(
                                child: Text("Error loading data"),
                              );
                            }

                            appliedJobs = snapshot.data!.docs;

                            return appliedJobs.isEmpty
                                ? const Center(
                                    child: Text('No Applications'),
                                  )
                                : ListView.builder(
                                    itemCount: appliedJobs.length,
                                    itemBuilder: (context, index) {
                                      var username =
                                          appliedJobs[index]['username'];
                                      var jobTitle =
                                          appliedJobs[index]['jobName'];
                                      var proPicURL =
                                          appliedJobs[index]['profilePicUrl'];

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: proPicURL == null
                                                  ? const AssetImage(
                                                      'assets/person.png')
                                                  : NetworkImage(proPicURL)
                                                      as ImageProvider,
                                              // backgroundColor: Colors.purpleAccent,
                                              // child: Icon(Icons.person,
                                              //     size: 30, color: Colors.white),
                                            ),
                                            title: Text(username),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(jobTitle),
                                                // Add any other details you want to display here
                                              ],
                                            ),
                                            trailing: const Icon(
                                                Icons.keyboard_arrow_right),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompanyViewStudentProfile(
                                                    username: username,
                                                    jobTitle: jobTitle,
                                                    proPicURL: proPicURL,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}

class StudentSearchDelegate extends SearchDelegate<String> {
  final List<QueryDocumentSnapshot> appliedJobs;

  StudentSearchDelegate(this.appliedJobs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = appliedJobs
        .where((appliedJob) =>
            appliedJob['jobTitle'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]['jobTitle']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyViewStudentProfile(
                  username: suggestionList[index]['username'],
                  jobTitle: suggestionList[index]['jobTitle'],
                  proPicURL: suggestionList[index]['profilePicUrl'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CompanyViewStudentProfile extends StatefulWidget {
  final String username;
  final String jobTitle;
  final String proPicURL;

  const CompanyViewStudentProfile({
    Key? key,
    required this.username,
    required this.jobTitle,
    required this.proPicURL,
  }) : super(key: key);

  @override
  State<CompanyViewStudentProfile> createState() =>
      _CompanyViewStudentProfileState();
}

class _CompanyViewStudentProfileState extends State<CompanyViewStudentProfile> {
  var dob = TextEditingController();
  var phone_number = TextEditingController();
  var age = TextEditingController();
  var gender = TextEditingController();
  var cgpa = TextEditingController();
  var qualification = TextEditingController();
  var certification = TextEditingController();
  var skills = TextEditingController();
  var username = '';
  var field = '';
  var email = '';
  var resumeURL = '';
  var proPic;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('applied_jobs')
          .where('username', isEqualTo: widget.username)
          .where('jobTitle', isEqualTo: widget.jobTitle)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        print('Entered to usersnapshot');
        final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

        username = userData['username'] ?? '';
        field = userData['field'] ?? '';
        email = userData['email'] ?? '';
        dob.text = userData['dob'] ?? '';
        phone_number.text = userData['phone'] ?? '';
        gender.text = userData['gender'] ?? '';
        cgpa.text = userData['cgpa'] ?? '';
        qualification.text = userData['qualification'] ?? '';
        certification.text = userData['certification'] ?? '';
        skills.text = userData['skills'] ?? '';
        resumeURL = userData['resume'] ?? '';
        proPic = userData['profilePicUrl'] ?? '';
      } else {
        print(
            'No data found for username: ${widget.username} and jobTitle: ${widget.jobTitle}');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> _shortListCandidate() async {
    try {
      // Update the status field to 'shortlisted' in Firestore
      await FirebaseFirestore.instance
          .collection('applied_jobs')
          .where('username', isEqualTo: widget.username)
          .where('jobTitle', isEqualTo: widget.jobTitle)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'status': 'shortlisted'});
          showToast('Candidate shortlisted');
          // Optionally, you can perform any other actions after shortlisting
        }
      });
    } catch (error) {
      print('Error shortlisting candidate: $error');
    }
  }

  Future<void> _rejectCandidate() async {
    try {
      // Update the status field to 'rejected' in Firestore
      await FirebaseFirestore.instance
          .collection('applied_jobs')
          .where('username', isEqualTo: widget.username)
          .where('jobTitle', isEqualTo: widget.jobTitle)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'status': 'rejected'});
          showToast('Candidate rejected');
          // Optionally, you can perform any other actions after rejecting
        }
      });
    } catch (error) {
      print('Error rejecting candidate: $error');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchUserDetails(),
          builder: (context, snapshot) {
            print('DOB : ${dob.text}');
            print('Phone Number : ${phone_number.text}');
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: proPic == null
                                      ? const AssetImage('assets/person.png')
                                      : NetworkImage(proPic!) as ImageProvider,
                                )),
                            Text(
                              username,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              field,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: dob,
                                decoration: InputDecoration(
                                  labelText: 'DOB',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Date of Birth',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: phone_number,
                                decoration: InputDecoration(
                                  labelText: 'Phonenumber',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Phone No',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: gender,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Gender',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: cgpa,
                            decoration: InputDecoration(
                              labelText: 'CGPA',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'CGPA',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: qualification,
                            decoration: InputDecoration(
                              labelText: 'Qualification',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Qualification',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: skills,
                            decoration: InputDecoration(
                              labelText: 'Skills',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Skills',
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewResume(
                                        studentName: username,
                                        studentResumeUrl: resumeURL),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('View Resume'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _shortListCandidate();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('ShortList'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: _rejectCandidate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
