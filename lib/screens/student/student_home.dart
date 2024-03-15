// ignore_for_file: unused_import, use_key_in_widget_constructors, avoid_print

import 'package:campus_recruitment/screens/student/job application.dart';
import 'package:campus_recruitment/screens/student/notificaiton.dart';
import 'package:campus_recruitment/screens/student/saved%20jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> savedJobs = [];
  String userid = '';
  String userName = '';
  String userEmail = '';
  String userNumber = '';
  String userDOB = '';
  String userQualification = '';
  String cgpa = '';
  String userGender = '';
  String userSkills = '';
  String? proPicUrl;

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: fetchUsers(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.hasError
                    ? Center(
                        child: Text(snapshot.error.toString()),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 50, left: 20),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: proPicUrl == null
                                            ? const AssetImage(
                                                'assets/person.png')
                                            : NetworkImage(proPicUrl!)
                                                as ImageProvider,
                                        radius: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Welcome',
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth > 600
                                                ? 30
                                                : 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.save,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SavedJobs(
                                                savedJobs: savedJobs,
                                                userid: userid,
                                                userEmail: userEmail,
                                                userName: userName,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.notification_add_outlined,
                                      //     color: Colors.blue,
                                      //   ),
                                      //   onPressed: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const NotificationPage(),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(top: 20, left: 15),
                                //   child: Container(
                                //     height: 50,
                                //     width: constraints.maxWidth > 550
                                //         ? null
                                //         : constraints.maxWidth,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       color: const Color(0XFFD3D3D3),
                                //     ),
                                //     child: const Row(
                                //       children: [
                                //         Padding(
                                //           padding: EdgeInsets.all(8.0),
                                //           child: Icon(Icons.search),
                                //         ),
                                //         Expanded(
                                //           child: Padding(
                                //             padding: EdgeInsets.only(left: 8.0),
                                //             child: TextField(
                                //               decoration: InputDecoration(
                                //                 hintText: 'Job Search',
                                //                 border: InputBorder.none,
                                //                 hintStyle: TextStyle(
                                //                     color: Colors.black),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //         Padding(
                                //           padding: EdgeInsets.only(right: 8.0),
                                //           child: CircleAvatar(
                                //             backgroundColor: Colors.blue,
                                //             child: Icon(
                                //               Icons.sort_outlined,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 40, left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recommendation',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: constraints.maxWidth > 600
                                              ? 25
                                              : 20,
                                        ),
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.only(right: 10.0),
                                      //   child: Text(
                                      //     'View more',
                                      //     style: TextStyle(
                                      //       color: Colors.blue,
                                      //       fontSize: constraints.maxWidth > 600
                                      //           ? 20
                                      //           : 15,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.3,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('jobs')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      var jobs = snapshot.data!.docs;

                                      return jobs.isEmpty
                                          ? const Center(
                                              child: Text('No Jobs Found'))
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: jobs.length,
                                              itemBuilder: (context, index) {
                                                var job = jobs[index].data()
                                                    as Map<String, dynamic>;

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    elevation: 5,
                                                    child: Container(
                                                      // height: constraints.maxWidth > 500
                                                      //     ? 180
                                                      //     : constraints.maxWidth * 0.5,
                                                      width: constraints
                                                                  .maxWidth >
                                                              600
                                                          ? 180
                                                          : constraints
                                                                  .maxWidth *
                                                              1.2,
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/Company-Vectors .png'),
                                                                  maxRadius: 30,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      job['companyname'] ??
                                                                          'Unknown',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: constraints.maxWidth >
                                                                                600
                                                                            ? 25
                                                                            : 20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      job['address'] ??
                                                                          'Unknown',
                                                                          maxLines: 2,
                                                                      style: const TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        job['jobTitle'] ??
                                                                            'Unknown',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize: constraints.maxWidth > 600
                                                                              ? 20
                                                                              : 16,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // const Spacer(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            50),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    Map<String,
                                                                            String>
                                                                        savedJob =
                                                                        {
                                                                      'companyname':
                                                                          job['companyname'] ??
                                                                              'Unknown',
                                                                      'companyId':
                                                                          job['companyId'] ??
                                                                              'Unknown',
                                                                      'address':
                                                                          job['address'] ??
                                                                              'Unknown',
                                                                      'jobTitle':
                                                                          job['jobTitle'] ??
                                                                              'Unknown',
                                                                      'field': job[
                                                                              'field'] ??
                                                                          'Unknown',
                                                                      'jobType':
                                                                          job['jobType'] ??
                                                                              'Unknown'
                                                                    };

                                                                    savedJobs.add(
                                                                        savedJob);

                                                                    await _firestore
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            userid)
                                                                        .collection(
                                                                            'savedjobs')
                                                                        .doc(
                                                                            '${savedJobs[index]['companyname']} ${savedJobs[index]['jobTitle']}')
                                                                        .set({
                                                                      'username':
                                                                          userName,
                                                                      'email':
                                                                          userEmail,
                                                                      'jobDetails':
                                                                          savedJob,
                                                                      'timestamp':
                                                                          FieldValue
                                                                              .serverTimestamp(),
                                                                    });

                                                                    // Navigator.push(
                                                                    //   context,
                                                                    //   MaterialPageRoute(
                                                                    //     builder: (context) =>
                                                                    //         SavedJobs(
                                                                    //             savedJobs:
                                                                    //                 savedJobs),
                                                                    //   ),
                                                                    // );
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .confirmation_num),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10.0),
                                                                child: Text(job[
                                                                        'position'] ??
                                                                    'Unknown'),
                                                              ),
                                                              const Text(
                                                                '•',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(job[
                                                                      'category'] ??
                                                                  'Unknown'),
                                                              const Text(
                                                                '•',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(job[
                                                                      'jobType'] ??
                                                                  'Unknown'),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 18.0),
                                                            child: TextButton(
                                                              onPressed:
                                                                  () async {
                                                                String
                                                                    loggedInUserId =
                                                                    userid;

                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            JobApplication(
                                                                      userId:
                                                                          loggedInUserId,
                                                                      jobTitle:
                                                                          job['jobTitle'],
                                                                      address: job[
                                                                          'address'],
                                                                      companyname:
                                                                          job['companyname'],
                                                                      userDOB:
                                                                          userDOB,
                                                                      userEmail:
                                                                          userEmail,
                                                                      userGender:
                                                                          userGender,
                                                                      userName:
                                                                          userName,
                                                                      userNumber:
                                                                          userNumber,
                                                                      userQualification:
                                                                          userQualification,
                                                                      userSkills:
                                                                          userSkills,
                                                                      cgpa:
                                                                          cgpa,
                                                                      proPicUrl:
                                                                          proPicUrl!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Colors.blue,
                                                                // primary: Colors
                                                                //     .white,
                                                              ),
                                                              child: const Text(
                                                                  'Apply Now'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Events',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: constraints.maxWidth > 600
                                              ? 30
                                              : 25,
                                        ),
                                      ),
                                      // Text(
                                      //   'View more',
                                      //   style: TextStyle(
                                      //     color: Colors.blue,
                                      //     fontSize: constraints.maxWidth > 600
                                      //         ? 20
                                      //         : 15,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      constraints.maxWidth > 600 ? 230 : 280,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('events')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      var events = snapshot.data!.docs;

                                      return events.isEmpty
                                          ? const Center(
                                              child: Text('No Events Found'),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: events.length,
                                              itemBuilder: (context, index) {
                                                var event = events[index].data()
                                                    as Map<String, dynamic>;

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    elevation: 5,
                                                    child: Container(
                                                      height: constraints
                                                                  .maxWidth >
                                                              300
                                                          ? 100
                                                          : constraints
                                                                  .maxWidth *
                                                              0.2,
                                                      width: constraints
                                                                  .maxWidth >
                                                              500
                                                          ? 250
                                                          : constraints
                                                                  .maxWidth *
                                                              0.7,
                                                      color: Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Image.asset(
                                                                'assets/events.jpg',
                                                                height: 150,
                                                                width: double
                                                                    .infinity,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              Positioned(
                                                                top: 8,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        'Event Date: ${event['eventDate']}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Event Name: ${event['eventName']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Event Time: ${event['eventTime']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Place: ${event['eventLocation']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
          }),
    );
  }
}
