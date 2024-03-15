import 'package:flutter/material.dart';

class ShortlistPage extends StatelessWidget {
  const ShortlistPage({super.key});

  // Implement your Shortlist page here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortlist Page'),
      ),
      body: const Center(
        child: Text('This is the Shortlist Page'),
      ),
    );
  }
}
