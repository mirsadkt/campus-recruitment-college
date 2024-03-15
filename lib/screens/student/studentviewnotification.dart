import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:${message.notification?.title}');
  print('Body:${message.notification?.body}');
  print('Payload:${message.data}');
}

class FirebaseApi {
  final _FirebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _FirebaseMessaging.requestPermission();
    final fCMToken = await _FirebaseMessaging.getToken();
    print('Token:$fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
/**how to get current working flutter projects FCM registration token */