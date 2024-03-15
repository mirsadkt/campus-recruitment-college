import 'package:campus_recruitment/screens/student/Past%20events.dart';
import 'package:campus_recruitment/screens/student/Upcoming%20event.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  // Replace this list with your actual list of event data
  // final List<Map<String, dynamic>> events = [
  //   {
  //     'title': 'Event 1',
  //     'date': 'Date 1',
  //     'location': 'Location 1',
  //     'image': 'assets/Womensday.png',
  //   },
  //   {
  //     'title': 'Event 2',
  //     'date': 'Date 2',
  //     'location': 'Location 2',
  //     'image': 'assets/Mother Day.png',
  //   },
  //   // Add more events as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Page'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sliding button with texts (Upcoming & Past Events)
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpcomingEvents(),
                        ),
                      );
                    },
                    child: const Text('Upcoming Events'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PastEvents(),
                        ),
                      ); // Handle button tap
                    },
                    child: const Text('Past Events'),
                  ),
                ),
              ],
            ),
          ),

          // ListView.builder with Card in each ListTile
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Womensday.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'date',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          'title',
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        Text(
                          'location',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle event tap
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
