import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < 10; i++) // Displaying only 3 cards for brevity
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.wallet,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    title: Text('Students wants to Apply!'),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.alarm,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
