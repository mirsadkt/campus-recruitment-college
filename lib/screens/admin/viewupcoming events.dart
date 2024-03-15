import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewUpcomingEvents extends StatefulWidget {
  const ViewUpcomingEvents({Key? key}) : super(key: key);

  @override
  State<ViewUpcomingEvents> createState() => _ViewUpcomingEventsState();
}

class _ViewUpcomingEventsState extends State<ViewUpcomingEvents> {
  late List<DocumentSnapshot> upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUpcomingEvents();
  }

  Future<void> _fetchUpcomingEvents() async {
    DateTime currentDate = DateTime.now();
    QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventDate', isGreaterThanOrEqualTo: currentDate)
        .get();

    setState(() {
      upcomingEvents = eventsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events"),
      ),
      body: ListView.builder(
        itemCount: upcomingEvents.length,
        itemBuilder: (context, index) {
          var event = upcomingEvents[index].data() as Map<String, dynamic>;

          return Card(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name: ${event['eventName']}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    'Event Date: ${event['eventDate']}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    'Event Time: ${event['eventTime']}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    'Event Location: ${event['eventLocation']}',
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
    );
  }
}
