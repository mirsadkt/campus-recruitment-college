// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class JobDetailView extends StatelessWidget {
//   final String jobDocumentId;

//   const JobDetailView({required this.jobDocumentId, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Job Details'),
//       ),
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance
//             .collection('jobs')
//             .doc(jobDocumentId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           // Check if the document exists
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('Job not found.'));
//           }

//           // Access the job data
//           Map<String, dynamic>? jobData = snapshot.data?.data();

//           // Check if fields are present in the document
//           String location = jobData?['location'] ?? 'N/A';
//           String description = jobData?['description'] ?? 'N/A';
//           List<String> expectedSkills =
//               jobData?['expectedSkills']?.cast<String>() ?? [];

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Location: $location'),
//                 SizedBox(height: 10),
//                 Text('Description: $description'),
//                 SizedBox(height: 10),
//                 Text('Expected Skills: ${expectedSkills.join(', ')}'),
//                 // Add more details as needed
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
