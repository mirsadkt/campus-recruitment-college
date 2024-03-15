// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavedJobs extends StatefulWidget {
  const SavedJobs({
    Key? key,
    required this.savedJobs,
    required this.userid,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  final List<Map<String, String>> savedJobs;
  final String userid;
  final String userName;
  final String userEmail;

  @override
  _SavedJobsState createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  String? jobTitle;
  String? companyName;
  List<Map<String, dynamic>> savedJobsList = [];
  @override
  Widget build(BuildContext context) {
    print(widget.userid);
    print(widget.userEmail);
    print(widget.userName);
    // Replace 'loggedInUsername' and 'loggedInUserEmail' with actual user information
    // List<Map<String, String>> userSavedJobs = widget.savedJobs
    //     .where((job) =>
    //         job['username'] == widget.userName &&
    //         job['email'] == widget.userEmail)
    //     .toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Job Details"),
        ),
        body: FutureBuilder(
            future: getSavedJobs(widget.userEmail),
            builder: (context, snapshot) {
              // print(snapshot.data["timestamp"]);
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : savedJobsList.isEmpty
                      ? const Center(
                          child: Text('No Saved jobs'),
                        )
                      : ListView.builder(
                          itemCount: savedJobsList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> jobData = savedJobsList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  title: Text(jobData['jobTitle']),
                                  subtitle: Text(jobData['companyname']),
                                ),
                              ),
                            );
                          },
                        );
            })
        //  Column(
        //   children: userSavedJobs.map(buildCard).toList(),
        // ),
        );
  }

  Future getSavedJobs(String userEmail) async {
    savedJobsList.clear();
    print('////////////////////////$userEmail');
    CollectionReference savedJobCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userid)
        .collection('savedjobs');

    try {
      QuerySnapshot savedJobSnaphot =
          await savedJobCollection.where('email', isEqualTo: userEmail).get();

      for (var jobDoc in savedJobSnaphot.docs) {
        Map<String, dynamic> jobData = {
          'email': jobDoc['email'],
          'jobTitle': jobDoc['jobDetails']['jobTitle'],
          'companyname': jobDoc['jobDetails']['companyname'],
        };
        print('///////////for in completed///////////////////');

        savedJobsList.add(jobData);

        print(jobDoc);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildCard(Map<String, String> jobDetails) {
    String companyname = jobDetails['companyname'] ?? '';
    String companyaddress = jobDetails['address'] ?? '';
    String jobTitle = jobDetails['jobTitle'] ?? '';
    String field = jobDetails['field'] ?? '';
    String schedule = jobDetails['schedule'] ?? '';
    String jobType = jobDetails['jobType'] ?? '';

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Image, Company Name, Place, Save Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/google.png'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text('address'),
                    ],
                  ),
                ),

                // Save Button as Icon
                IconButton(
                  onPressed: () {
                    // Handle save button tap
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),

            // Second Row: Job Heading, Post, Time Schedule, Job Type
            const SizedBox(height: 10), // Add some space between rows
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Heading
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                          height:
                              5), // Add some space between heading and other details

                      // Other details with dotted pointers
                      Row(
                        children: [
                          Text(field),
                          const SizedBox(width: 5),
                          const Icon(Icons.fiber_manual_record, size: 8),
                          const SizedBox(width: 5),
                          Text(schedule),
                          const SizedBox(width: 5),
                          const Icon(Icons.fiber_manual_record, size: 8),
                          const SizedBox(width: 5),
                          Text(jobType),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
