import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CompanyBugReport extends StatefulWidget {
  const CompanyBugReport({super.key});

  @override
  State<CompanyBugReport> createState() => _CompanyBugReportState();
}

class _CompanyBugReportState extends State<CompanyBugReport> {
  var shortDescription = TextEditingController();
  var email = TextEditingController();
  var complaint = TextEditingController();
  var resolve = TextEditingController();
  String? filePath; // Variable to store the selected file path

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  Future<void> _submitBugReport() async {
    try {
      // Log bug information to Crashlytics.
      FirebaseCrashlytics.instance
          .log('Short Description: ${shortDescription.text}');
      FirebaseCrashlytics.instance.log('Email: ${email.text}');
      FirebaseCrashlytics.instance.log('What Happened: ${complaint.text}');
      FirebaseCrashlytics.instance.log('Expected Outcome: ${resolve.text}');

      // Add bug report to Firestore
      await FirebaseFirestore.instance.collection('bugreport').add({
        'shortDescription': shortDescription.text,
        'email': email.text,
        'complaint': complaint.text,
        'resolve': resolve.text,
        'filePath': filePath,
      });

      // Handle the bug report submission.
      // You can add additional logic here.

      // Clear form fields after submission
      shortDescription.clear();
      email.clear();
      complaint.clear();
      resolve.clear();

      setState(() {
        filePath = null; // Clear the selected file path
      });
    } catch (e) {
      print('Error submitting bug report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 350, top: 50),
              child: CircleAvatar(
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back when the back arrow is pressed
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                height: 100,
                width: 300,
                child: Image.asset(
                  'assets/bug-fill.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: shortDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Short Description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: complaint,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'What Happened?',
                ),
                maxLines: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: resolve,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'What did you expect to happen?',
                ),
                maxLines: 4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select resume '),
                const Icon(Icons.cloud_upload_outlined),
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Browse file'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _submitBugReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
