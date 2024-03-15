// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class Jobpost4 extends StatefulWidget {
//   final String jobDocumentId;

//   const Jobpost4({required this.jobDocumentId, super.key});

//   @override
//   State<Jobpost4> createState() => _Jobpost4State();
// }

// class _Jobpost4State extends State<Jobpost4> {
//   List<String> expectedSkills = [];
//   String newSkill = "";

//   // Controller for the new skill input field
//   TextEditingController newSkillController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Job Posting'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(top: 60, right: 170, bottom: 20),
//                 child: Text(
//                   "Expected Skills",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: expectedSkills.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundColor: Color(0XFF08F82F),
//                           radius: 5,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             expectedSkills[index],
//                             style: const TextStyle(fontSize: 15),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               if (expectedSkills.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Added Skills:",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       for (String skill in expectedSkills)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.check_circle,
//                                   color: Colors.green),
//                               const SizedBox(width: 8),
//                               Text(skill),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 5,
//                       backgroundColor: Color(0XFF08F82F),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextFormField(
//                         controller: newSkillController,
//                         onChanged: (value) {
//                           newSkill = value;
//                         },
//                         decoration: const InputDecoration(
//                           hintText: "Enter new skill",
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.save),
//                       onPressed: () {
//                         if (newSkill.isNotEmpty &&
//                             !expectedSkills.contains(newSkill)) {
//                           setState(() {
//                             expectedSkills.add(newSkill);
//                             newSkill = "";
//                             // Do not set this to false after saving the skill
//                           });
//                           // Clear the text field after saving the skill
//                           newSkillController.clear();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Get a reference to the job document
//                   final jobDocumentRef = FirebaseFirestore.instance
//                       .collection('jobs')
//                       .doc(widget.jobDocumentId);

//                   try {
//                     // Update the document with the new skills
//                     await jobDocumentRef.update({
//                       'expectedSkills': FieldValue.arrayUnion(expectedSkills),
//                       // Add more fields as needed
//                     });

//                     // Clear the expectedSkills list after posting the job
//                     setState(() {
//                       expectedSkills.clear();
//                     });

//                     // Show toast message
//                     Fluttertoast.showToast(
//                       msg: "Job added successfully",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                     );

//                     // Navigate back to Companyhome
//                     Navigator.pop(context);
//                   } catch (e) {
//                     print('Error updating document: $e');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0XFF9747FF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text("Post Job"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Jobpost4 extends StatefulWidget {
  final String jobDocumentId;

  const Jobpost4({required this.jobDocumentId, Key? key}) : super(key: key);

  @override
  State<Jobpost4> createState() => _Jobpost4State();
}

class _Jobpost4State extends State<Jobpost4> {
  List<String> expectedSkills = [];
  String newSkill = "";

  // Controller for the new skill input field
  TextEditingController newSkillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Posting'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 60, right: 170, bottom: 20),
                      child: Text(
                        "Expected Skills",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: expectedSkills.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0XFF08F82F),
                                radius: 5,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  expectedSkills[index],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (expectedSkills.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Added Skills:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            for (String skill in expectedSkills)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(skill),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0XFF08F82F),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: newSkillController,
                              onChanged: (value) {
                                newSkill = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter new skill",
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (newSkill.isNotEmpty &&
                                  !expectedSkills.contains(newSkill)) {
                                setState(() {
                                  expectedSkills.add(newSkill);
                                  newSkill = "";
                                });
                                newSkillController.clear();
                              }
                            },
                            child: Text("Add"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get a reference to the job document
              final jobDocumentRef = FirebaseFirestore.instance
                  .collection('jobs')
                  .doc(widget.jobDocumentId);

              try {
                // Update the document with the new skills
                await jobDocumentRef.update({
                  'expectedSkills': FieldValue.arrayUnion(expectedSkills),
                  // Add more fields as needed
                });

                // Clear the expectedSkills list after posting the job
                setState(() {
                  expectedSkills.clear();
                });

                // Show toast message
                Fluttertoast.showToast(
                  msg: "Job added successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                // Navigate to Companyhome
                Navigator.pushReplacementNamed(context, '/companyhome');
              } catch (e) {
                print('Error updating document: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF9747FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: Colors.white,
            ),
            child: const Text("Post Job"),
          ),
        ],
      ),
    );
  }
}
