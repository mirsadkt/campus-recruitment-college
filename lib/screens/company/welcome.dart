import 'package:campus_recruitment/screens/company/login.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/company welcome.png',
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Welcome',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Recruitment App',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Application for easy job  search and Job Providers',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const CompanyLogIn();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('Job Providers')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
