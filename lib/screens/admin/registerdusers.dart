import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredUsers extends StatelessWidget {
  const RegisteredUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Extract data from snapshot
          final List<QueryDocumentSnapshot> users = snapshot.data!.docs;

          if (users.isEmpty) {
            // Display a message if there is no data
            return const Center(
              child: Text('No data available'),
            );
          }

          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : users.isEmpty
                  ? const Center(
                      child: Text('No users found!'),
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        // Extract fields from the user document with default values
                        final name = users[index]['name'] as String? ?? 'N/A';
                        final username =
                            users[index]['username'] as String? ?? 'N/A';
                        final field =
                            users[index]['field'] as String? ?? 'not available';
                        final email = users[index]['email'] as String? ?? 'N/A';

                        return Card(
                          margin: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.account_circle, size: 40.0),
                            title: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Text('Email: $email',
                                    style: const TextStyle(fontSize: 16.0)),
                                Text('Username: $username',
                                    style: const TextStyle(fontSize: 16.0)),
                                Text('Field: $field',
                                    style: const TextStyle(fontSize: 16.0)),
                              ],
                            ),
                            onTap: () {
                              // Implement navigation to the detailed view if needed
                            },
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
