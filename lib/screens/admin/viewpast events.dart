import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPastEvent extends StatefulWidget {
  const ViewPastEvent({super.key});

  @override
  State<ViewPastEvent> createState() => _ViewPastEventState();
}

class _ViewPastEventState extends State<ViewPastEvent> {
  late List<DocumentSnapshot> pastEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchPastEvents();
  }

  Future<void> _fetchPastEvents() async {
    DateTime currentDate = DateTime.now();
    QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventDate', isLessThan: currentDate)
        .get();

    setState(() {
      pastEvents = eventsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Past events")),
        ),
        body: SizedBox(
          child: Row(
            children: [
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              'title',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            Text(
                              'location',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
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
        ));
  }
}
