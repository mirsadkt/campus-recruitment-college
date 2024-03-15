import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostedJobs extends StatefulWidget {
  const PostedJobs({Key? key}) : super(key: key);

  @override
  State<PostedJobs> createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posted Jobs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('companyId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading data"),
            );
          }

          var shortlistedCandidates = snapshot.data!.docs;

          if (shortlistedCandidates.isEmpty) {
            return const Center(
              child: Text("No Jobs found."),
            );
          }

          return ListView.builder(
            itemCount: shortlistedCandidates.length,
            itemBuilder: (context, index) {
              var jobTitle = shortlistedCandidates[index]['jobTitle'];
              var jobDesc = shortlistedCandidates[index]['description'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    title: Text(
                      jobTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(jobDesc),

                    // Add any other details you want to display here
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
