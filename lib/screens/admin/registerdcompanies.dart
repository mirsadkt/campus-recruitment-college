import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredCompanies extends StatelessWidget {
  const RegisteredCompanies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Companies'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('companies').snapshots(),
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
          final List<DocumentSnapshot> companies = snapshot.data!.docs;

          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : companies.isEmpty
                  ? const Center(
                      child: Text('No companies found!'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: companies.map((document) {
                          // Extract fields from the company document with null checks
                          final companyName =
                              document['companyname'] as String? ?? 'N/A';
                          final companyAddress =
                              document['address'] as String? ?? 'N/A';
                          final companyEmail =
                              document['email'] as String? ?? 'N/A';
                          final companyLicNo =
                              document['companyLicNo'] as String? ?? 'N/A';
                          final companyId =
                              document['companyId'] as String? ?? 'N/A';

                          return Stack(
                            children: [
                              Card(
                                margin: const EdgeInsets.all(16.0),
                                child: ListTile(
                                  leading: const Icon(Icons.work,
                                      size: 40.0), // Add user icon here
                                  title: Text(
                                    companyName,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8.0),
                                      Text('Address: $companyAddress',
                                          style:
                                              const TextStyle(fontSize: 16.0)),
                                      Text('Email: $companyEmail',
                                          style:
                                              const TextStyle(fontSize: 16.0)),
                                      Text('Lic No: $companyLicNo',
                                          style:
                                              const TextStyle(fontSize: 16.0)),
                                    ],
                                  ),

                                  // You can add more actions if needed
                                  // For example, navigate to a detailed view of the company
                                  onTap: () {
                                    // Implement navigation to the detailed view
                                  },
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton.filled(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red)),
                                    visualDensity: VisualDensity.compact,
                                    splashRadius: 0.5,
                                    iconSize: 15,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Delete Company?'),
                                            content: Text(
                                                'Are you sure you want to delete $companyName'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    final companiesCollection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'companies');
                                                    final companyDoc =
                                                        companiesCollection
                                                            .doc(companyId);
                                                    await companyDoc.delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete')),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                    )),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    );
        },
      ),
    );
  }
}
