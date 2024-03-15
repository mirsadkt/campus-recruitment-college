import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Job Description',
      body: 'Position',
      footer: SizedBox(
        height: 45,
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
          ),
          onPressed: () {},
          child: const Text('Next', style: TextStyle(fontSize: 20)),
        ),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyWidget: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Job Position'),
        items: [
          'Software Engineer',
          'Product Manager',
          'Data Scientist',
          'UI/UX Designer',
          'Marketing Manager',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          // Handle dropdown value change
        },
      ),
    ),
    PageViewModel(
        title: 'Have Access Everywhere!',
        body:
            'Here you can have whatever description you would like to have, you can type it all in here',
        footer: SizedBox(
          height: 45,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8),
            onPressed: () {},
            child: const Text(
              "Why to wait!",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        image: Center(
          child: Image.asset('assets/person.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
    PageViewModel(
        title: 'Here We Start!',
        body:
            'Here you can have whatever description you would like to have, you can type it all in here',
        footer: SizedBox(
          height: 45,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8),
            onPressed: () {},
            child: const Text("Let's Start", style: TextStyle(fontSize: 20)),
          ),
        ),
        image: Center(
          child: Image.asset('assets/3.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter on Boarding UI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(15, 15),
            color: Colors.blue,
            activeSize: Size.square(20),
            activeColor: Colors.red,
          ),
          showDoneButton: true,
          done: const Text(
            'Done',
            style: TextStyle(fontSize: 20),
          ),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(fontSize: 20),
          ),
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            size: 25,
          ),
          onDone: () => onDone(context),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  void onDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
