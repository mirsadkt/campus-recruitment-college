import 'package:campus_recruitment/screens/student/Studentprofile.dart';
import 'package:campus_recruitment/screens/student/joblisting.dart';
import 'package:campus_recruitment/screens/student/settings.dart';
import 'package:campus_recruitment/screens/student/student_home.dart';
import 'package:flutter/material.dart';

class StudentBottomNavigation extends StatefulWidget {
  const StudentBottomNavigation({
    super.key,
  });

  @override
  State<StudentBottomNavigation> createState() =>
      _StudentBottomNavigationState();
}

class _StudentBottomNavigationState extends State<StudentBottomNavigation> {
  int currentIndex = 0;
  final pages = [
    const StudentHome(),
    const JobListing(),
    const Settings(),
    const StudentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, // Adjust the notch margin as needed
        child: SizedBox(
          height: 60.0, // Increase the height of the BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.home, 0),
              _buildIconButton(Icons.auto_graph_outlined, 1),
              _buildIconButton(Icons.settings, 2),
              _buildIconButton(Icons.perm_identity_sharp, 3),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildIconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon),
      color: currentIndex == index ? Colors.blue : Colors.black,
      onPressed: () {
        _changePage(index);
      },
    );
  }

  void _changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
