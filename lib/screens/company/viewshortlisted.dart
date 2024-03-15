import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShortListCandidates extends StatefulWidget {
  final String companyName;
  const ShortListCandidates({required this.companyName,Key? key}) : super(key: key);

  @override
  State<ShortListCandidates> createState() => _ShortListCandidatesState();
}

class _ShortListCandidatesState extends State<ShortListCandidates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortlisted Candidates'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('applied_jobs')
            .where('status', isEqualTo: 'shortlisted').where('companyname',isEqualTo:widget.companyName )
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
              child: Text("No shortlisted candidates found."),
            );
          }

          return ListView.builder(
            itemCount: shortlistedCandidates.length,
            itemBuilder: (context, index) {
              var username = shortlistedCandidates[index]['username'];
              var jobName = shortlistedCandidates[index]['jobName'];

              return ListTile(
                title: Text(username),
                subtitle: Text(jobName),
                // Add any other details you want to display here
              );
            },
          );
        },
      ),
    );
  }
}
