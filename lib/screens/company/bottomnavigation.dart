import 'package:campus_recruitment/screens/company/comapnyprofile.dart';
import 'package:campus_recruitment/screens/company/companyhome.dart';
import 'package:campus_recruitment/screens/company/settingspage.dart';
import 'package:campus_recruitment/screens/company/studentlist.dart';
import 'package:flutter/material.dart';

class CompanyBottomNavigations extends StatefulWidget {
  const CompanyBottomNavigations({
    super.key,
  });

  @override
  State<CompanyBottomNavigations> createState() =>
      _CompanyBottomNavigationsState();
}

class _CompanyBottomNavigationsState extends State<CompanyBottomNavigations> {
  int currentIndex = 0;
  final pages = [
    const CompanyHome(),
    const StudentList(),
    const CompanySettingsPage(),
    const CompanyProfilePage(),
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
              _buildIconButton(Icons.library_books_outlined, 1),
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
      color: currentIndex == index ? Colors.purple : Colors.black,
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
