// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: FutureBuilder(
//         future:
//             _getNotifications(), // Function to get notifications from Firebase
//         builder: (context, AsyncSnapshot<List<NotificationData>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No notifications available.'));
//           } else {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.1),
//                     child: const Padding(
//                       padding: EdgeInsets.only(top: 50.0),
//                       child: Text(
//                         'Notifications',
//                         style: TextStyle(fontSize: 30),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   for (var notification in snapshot.data!)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Card(
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             child: Icon(
//                               notification.icon,
//                               color: Colors.purpleAccent,
//                             ),
//                           ),
//                           title: Text(notification.title),
//                           subtitle: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.alarm,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 notification.timestamp,
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<NotificationData>> _getNotifications() async {
//     try {
//       // Fetch notifications from Firebase
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await _firestore.collection('notifications').get();

//       // Convert QuerySnapshot to a list of NotificationData
//       List<NotificationData> notifications = querySnapshot.docs
//           .map((doc) => NotificationData.fromMap(doc.data()))
//           .toList();

//       return notifications;
//     } catch (e) {
//       print("Error fetching notifications: $e");
//       throw e;
//     }
//   }
// }

// class NotificationData {
//   final IconData icon;
//   final String title;
//   final String timestamp;

//   NotificationData({
//     required this.icon,
//     required this.title,
//     required this.timestamp,
//   });

//   factory NotificationData.fromMap(Map<String, dynamic> map) {
//     return NotificationData(
//       icon: map['icon'] ?? Icons.info, // You can customize the default icon
//       title: map['title'] ?? 'Notification Title',
//       timestamp: map['timestamp'] ?? 'Just now',
//     );
//   }
// }
