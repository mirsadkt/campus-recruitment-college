// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'jobview1.dart';

class JobListing extends StatefulWidget {
  const JobListing({
    Key? key,
  }) : super(key: key);

  @override
  State<JobListing> createState() => _JobListingState();
}

class _JobListingState extends State<JobListing> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _jobsStream;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _jobsStream = _firestore.collection('jobs').snapshots();
  }

  String? proPicUrl;

  Future fetchUsers() async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot snapshot = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        proPicUrl = snapshot['profilePicUrl'];
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: FutureBuilder(
              future: fetchUsers(),
              builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundImage: proPicUrl == null
                      ? const AssetImage('assets/person.png')
                      : NetworkImage(proPicUrl!) as ImageProvider,
                  radius: 25,
                );
              }),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.blue,size: 28,),
              onPressed: () {
                // Handle search action
                showSearch(context: context, delegate: JobSearch(_firestore));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 13,
          ),
           Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Find your Dream job today",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('jobs').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var jobList = snapshot.data!.docs;

                return jobList.isEmpty
                    ? const Center(
                        child: Text('No Jobs Found',
                        ),
                      )
                    : ListView.builder(
                        itemCount: jobList.length,
                        itemBuilder: (context, index) {
                          var companyname =
                              jobList[index]['companyname'] as String?;
                          var jobTitle = jobList[index]['jobTitle'] as String?;
                          var companyId =
                              jobList[index]['companyId'] as String?;

                          // Check if fields are not null before using them
                          if (companyname != null && jobTitle != null) {
                            return buildJobCard(
                                context, companyname, jobTitle, companyId!);
                          } else {
                            // Handle the case where fields are null or not present
                            return Container();
                          }
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJobCard(BuildContext context, String companyname, String jobTitle,
      String companyId) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(companyname),
              subtitle: Text(jobTitle),
              leading: Image.asset('assets/Company-Vectors .png'),
              trailing: GestureDetector(
                onTap: () {
                  var jobDetails = JobDetails(
                    companyId: companyId,
                    companyname: companyname,
                    jobTitle: jobTitle,
                    jobType: '', // Add your data
                    position: '', // Add your data
                    category: '', // Add your data
                    expectedSkills: '', // Add your data
                    description: '', // Add your data
                    currentSalary: '', // Add your data
                    immediatStart: false, // Add your data
                    workDays: [], // Add your data
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JObview1(jobDetails: jobDetails),
                    ),
                  );
                },
                child:
                    const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobSearch extends SearchDelegate<String> {
  final FirebaseFirestore firestore;

  JobSearch(this.firestore);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String searchQuery) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('jobs')
          .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
          .where('jobTitle',
              isLessThan: searchQuery + 'z') // This might cause issues
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var jobList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobList.length,
          itemBuilder: (context, index) {
            var companyname = jobList[index]['companyname'] as String?;
            var jobTitle = jobList[index]['jobTitle'] as String?;
            var companyId = jobList[index]['companyId'] as String?;

            // Check if fields are not null before using them
            if (companyname != null && jobTitle != null) {
              return ListTile(
                title: Text(companyname),
                subtitle: Text(jobTitle),
                onTap: () {
                  // Handle tap on search result
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JObview1(
                        jobDetails: JobDetails(
                          companyId: companyId!,
                          companyname: companyname,
                          jobTitle: jobTitle,
                          jobType: '', // Add your data
                          position: '', // Add your data
                          category: '', // Add your data
                          expectedSkills: '', // Add your data
                          description: '', // Add your data
                          currentSalary: '', // Add your data
                          immediatStart: false, // Add your data
                          workDays: [], // Add your data
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
