import 'package:flutter/material.dart';

class CompanyViewStudentProfile extends StatefulWidget {
  const CompanyViewStudentProfile({super.key});

  @override
  State<CompanyViewStudentProfile> createState() =>
      _CompanyViewStudentProfileState();
}

class _CompanyViewStudentProfileState extends State<CompanyViewStudentProfile> {
  var dob = TextEditingController();
  var phone_number = TextEditingController();
  var age = TextEditingController();
  var gender = TextEditingController();
  var experience = TextEditingController();
  var qualification = TextEditingController();
  var certification = TextEditingController();
  var skills = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 100,
                    width: 300,
                    child: Image.asset(
                      'assets/person.png',
                    ),
                  ),
                ),
                const Text(
                  'name',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                  ),
                ),
                const Text(
                  'fiels',
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  'email ',
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: dob,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Date of Birth'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: phone_number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Phone No'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: gender,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Gender'),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: experience,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Experience'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: qualification,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Qualification'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: certification,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Certification'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: skills,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Skills'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('View Resume')),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('ShortList')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Reject')),
            ),
          ],
        ),
      ),
    );
  }
}
