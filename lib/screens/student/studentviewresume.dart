// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentViewResume extends StatelessWidget {
  final String resumeUrl;

  const StudentViewResume({Key? key, required this.resumeUrl})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadResume() async {
    try {
      String downloadUrl = await _getDownloadUrl(resumeUrl);
      print('Download URL: $downloadUrl');
      _launchURL(downloadUrl);
    } catch (e) {
      print('Error downloading resume: $e');
      // Handle error as needed
    }
  }

  Future<String> _getDownloadUrl(String resumeUrl) async {
    try {
      return await FirebaseStorage.instance.ref(resumeUrl).getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      throw Exception('Failed to get download URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Resume',
        style: GoogleFonts.poppins(
          fontWeight:FontWeight.w400
        ),),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
      await  _launchURL(resumeUrl);
            // _downloadResume();
          },
          child: const Text('Download Resume'),
        ),
      ),
    );
  }
}
