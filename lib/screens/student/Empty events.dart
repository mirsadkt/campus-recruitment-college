import 'package:flutter/material.dart';

class EmptyNotification extends StatefulWidget {
  const EmptyNotification({super.key});

  @override
  State<EmptyNotification> createState() => _EmptyNotificationState();
}

class _EmptyNotificationState extends State<EmptyNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350, // Set the width of the container
          height: 400, // Set the height of the container
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/empty.png', // Replace with your image asset
                width: 150, // Adjust the width of the image
              ),
              const SizedBox(height: 10),
              const Text(
                'No Upcoming Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
