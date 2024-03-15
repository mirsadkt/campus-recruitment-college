import 'dart:async';

import 'package:campus_recruitment/screens/admin/adminhome.dart';
import 'package:campus_recruitment/screens/company/bottomnavigation.dart';
import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'first.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(
  //       const Duration(seconds: 4),
  //       () => Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const LandingPage())));
  // }

  Future checkLogin(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      print('////////////////${auth.currentUser!.uid}');
      final String uid = auth.currentUser!.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final companyDoc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const StudentBottomNavigation(),
            ),
            (route) => false);
      } else if (companyDoc.exists) {
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CompanyBottomNavigations(),
            ),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AdminHome(),
            ),
            (route) => false);
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLogin(context),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF3F6CDF), // #3F6CDF
                          Color.fromRGBO(
                              29, 106, 221, 0.92), // rgba(29, 106, 221, 0.92)
                        ],
                      ),
                    ), // Use the navy blue color you desire
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/splash2.png'),
                          const SizedBox(
                            height: 10,
                          ),
                          const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  )
                : snapshot.hasError
                    ? Center(
                        child: Text('{snapshot.error.toString()}'),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF3F6CDF), // #3F6CDF
                              Color.fromRGBO(29, 106, 221,
                                  0.92), // rgba(29, 106, 221, 0.92)
                            ],
                          ),
                        ), // Use the navy blue color you desire
                        child: Center(
                          child: Image.asset('assets/splash2.png'),
                        ),
                      );
          }),
    );
  }
}
