import 'package:campus_recruitment/screens/company/jobpost1.dart';
import 'package:flutter/material.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card 1: Company Information
            Card(
              margin: const EdgeInsets.only(top: 40.0),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    // Company Logo
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/person.png',
                      ), // Add your company logo
                    ),
                    const SizedBox(width: 16.0),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello,', style: TextStyle(fontSize: 20.0)),
                        Text('Company Name', style: TextStyle(fontSize: 20.0)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Jobpost1(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent,
                      ),
                      child: const Text('Post a Job'),
                    ),
                  ],
                ),
              ),
            ),
            // Card 2: Job Positions
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Card(
                margin: EdgeInsets.only(top: 40.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      // Company Logo
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/facebook.png',
                        ), // Add your company logo
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Company Name',
                              style: TextStyle(fontSize: 20.0)),
                          Text('Company Name',
                              style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
