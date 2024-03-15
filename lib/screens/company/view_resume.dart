import 'package:flutter/material.dart';

class ViewResume extends StatelessWidget {
  final String studentName;
  final String studentResumeUrl;
  const ViewResume({
    required this.studentName,
    required this.studentResumeUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studentName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [Image.network(studentResumeUrl)],
          ),
        ),
      ),
    );
  }
}
