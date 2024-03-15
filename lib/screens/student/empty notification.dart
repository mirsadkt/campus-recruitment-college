import 'package:flutter/material.dart';

class EmptyEvents extends StatefulWidget {
  const EmptyEvents({super.key});

  @override
  State<EmptyEvents> createState() => _EmptyEventsState();
}

class _EmptyEventsState extends State<EmptyEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350, // Set the width of the container
          height: 400, // Set the height of the container
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Border color
              width: 2.0, // Border width
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/.png', // Replace with your image asset
                width: 150, // Adjust the width of the image
              ),
              const SizedBox(height: 10),
              const Text(
                'No Notifications yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Text(
                    "We'll notify you once we have something for you",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
