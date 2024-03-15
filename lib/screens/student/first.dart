import 'package:campus_recruitment/screens/admin/adminlogin.dart';
import 'package:campus_recruitment/screens/company/welcome.dart';
import 'package:flutter/material.dart';

import 'get started.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F6CDF), // #3F6CDF
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLogin(),
                ),
              );
            },
            child: const Text(
              'Administrator Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16), // Adjust the spacing as needed
        ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    child: Image.asset('assets/join us.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(50.0),
                  child: SizedBox(height: 35),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Getstarted(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3F6CDF), Color(0xFF3F6CDF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        width: screenWidth * 0.35,
                        height: 40,
                        child: const Center(
                          child: Text(
                            'Student Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomePage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3F6CDF), Color(0xFF3F6CDF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        width: screenWidth * 0.35,
                        height: 40,
                        child: const Center(
                          child: Text(
                            'Company Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
