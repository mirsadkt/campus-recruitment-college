import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'jobpost3.dart'; // Import the Jobpost3 file

class Jobpost2 extends StatefulWidget {
  final String documentId;

  const Jobpost2(this.documentId, {super.key});

  @override
  _Jobpost2State createState() => _Jobpost2State();
}

class _Jobpost2State extends State<Jobpost2> {
  String jobType = "";
  String workDays = "";
  bool immediateStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15),
                  child: Text(
                    'Job Details',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Job Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Part-time / Full-time',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0XFF9747FF),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'Part-time',
                      groupValue: jobType,
                      onChanged: (value) {
                        setState(() {
                          jobType = value.toString();
                        });
                      },
                    ),
                    const Text('Part-time'),
                    Radio(
                      value: 'Full-time',
                      groupValue: jobType,
                      onChanged: (value) {
                        setState(() {
                          jobType = value.toString();
                        });
                      },
                    ),
                    const Text('Full-time'),
                  ],
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Work days",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        buildDayButton('Mon'),
                        buildDayButton('Tue'),
                        buildDayButton('Wed'),
                        buildDayButton('Thu'),
                        buildDayButton('Fri'),
                        buildDayButton('Sat'),
                        buildDayButton('Sun'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Immediate Start:',
                        style: TextStyle(color: Colors.purple)),
                    Switch(
                      value: immediateStart,
                      onChanged: (value) {
                        setState(() {
                          print('immediate Joining : $value');
                          immediateStart = value;
                        });
                      },
                      activeColor: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () async {if (jobType == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select jobtype')));
                  }else{
                      // Get the currently logged-in user
                    // Assuming you have already initialized FirebaseAuth
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Prepare job data
                      Map<String, dynamic> jobData = {
                        'jobType': jobType,
                        'workDays': workDays,
                        'immediateStart': immediateStart,
                        // Add more fields as needed
                      };

                      // Update the existing document in Firestore
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(widget.documentId)
                          .update(jobData);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Jobpost3(documentId: widget.documentId),
                        ),
                      );
                    }
                  }

                  
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
        ],
      ),
    );
  }

  Widget buildDayButton(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              workDays = day;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: workDays == day ? Colors.blue : Colors.purple,
          ),
          child: Text(day),
        ),
      ),
    );
  }
}
