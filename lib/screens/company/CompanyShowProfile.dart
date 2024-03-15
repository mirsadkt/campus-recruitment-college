import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyShowProfile extends StatefulWidget {
  const CompanyShowProfile({super.key});

  @override
  _CompanyShowProfileState createState() => _CompanyShowProfileState();
}

class _CompanyShowProfileState extends State<CompanyShowProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? currentUser = _auth.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: /*Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Company-Vectors .png'), // Replace with your image asset path
              fit: BoxFit.fill,
            ),
          ),
          child:*/
          Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Display company details
              FutureBuilder<DocumentSnapshot>(
                future:
                    _firestore.collection('companies').doc(_user?.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Company details not found.');
                  } else {
                    var companyData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Name: ${companyData['companyname']}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email: ${companyData['email']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Address: ${companyData['address'] ?? 'Not provided'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Website: ${companyData['website']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Industry: ${companyData['industry']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Contact: ${companyData['phoneNo']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'About: ${companyData['about']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
