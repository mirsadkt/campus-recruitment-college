import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'studentlogin.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
              child: Image.asset('assets/get started .png'),
            ),
          ),
          const Text(
            'Welcome',
            style: TextStyle(fontSize: 40),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Get Hired with ease using our App',
              style: GoogleFonts.aBeeZee(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(70.0),
            child: Center(
              child: Text(
                'Take the First step towards your dream with our app',
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentLogIn(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3F6CDF), Color(0xFF3F6CDF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      width: screenWidth * 0.50,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Find your job',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
