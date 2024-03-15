import 'package:campus_recruitment/screens/company/jobpost1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({
    super.key,
  });

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String companyname = '';
  String? logoPic;

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo();
  }

  Future<void> _loadCompanyInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot companySnapshot =
            await _firestore.collection('companies').doc(user.uid).get();

        if (companySnapshot.exists) {
          companyname = companySnapshot['companyname'];
          
          logoPic = companySnapshot['userlogo'] ?? '';
         
        }
      }
    } catch (e) {
      print("Error loading company information: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _loadCompanyInfo(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                                backgroundImage: logoPic == ''
                                    ? const AssetImage('assets/person.png')
                                    : NetworkImage(logoPic!) as ImageProvider,
                                radius: 30),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Hello,',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    companyname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SizedBox(
                          height: 400,
                          width: 300,
                          child: Image.asset(
                            'assets/job.png',
                          ),
                        ),
                      ),
                      const Text('Post a Job and Hire',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'When you Post a Job,you can edit and promote',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Jobpost1(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              fixedSize: const Size.fromWidth(350),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text('Post a Job'),
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
