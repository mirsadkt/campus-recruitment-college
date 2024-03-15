// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FCM Token Example',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late FirebaseMessaging _firebaseMessaging;

//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging = FirebaseMessaging.instance;

//     // Request permission for receiving push notifications (optional)
//     FirebaseMessaging.instance.requestPermission();

//     // Listen for FCM token updates
//     _firebaseMessaging.getToken().then((token) {
//       print('FCM Token: $token');
//     });

//     // Listen for incoming messages while the app is in the foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Message data: ${message.data}");
//       print("Notification title: ${message.notification?.title}");
//       print("Notification body: ${message.notification?.body}");
//     });

//     // Listen for when the app is in the background and is opened from a notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Message data: ${message.data}");
//       print("Notification title: ${message.notification?.title}");
//       print("Notification body: ${message.notification?.body}");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FCM Token Example'),
//       ),
//       body: Center(
//         child: Text('Check the console for the FCM token'),
//       ),
//     );
//   }
// }
