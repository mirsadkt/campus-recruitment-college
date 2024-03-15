import 'package:campus_recruitment/screens/student/Past%20events.dart';
import 'package:flutter/material.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

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
                      );
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
                      width: 90,
                      height: 90,
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
