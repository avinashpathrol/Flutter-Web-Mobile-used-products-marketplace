// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   String? mtoken = " ";

//   late AndroidNotificationChannel channel;
//   // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   void saveToken(String token) async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc("lLHK5CEK4VGLVhP5Tuzt")
//         .update({
//       'token': token,
//     });
//   }

//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http
//           .post(
//             Uri.parse('https://fcm.googleapis.com/fcm/send'),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization':
//                   'key=AAAAuthZrXA:APA91bE5bHEQ32MzLhD-R9rZDYMTo4Hzhhw3-rhOo5oHdpH46fPFWuNwT-ougm4Bau4JkxcHvsQYzQsNPsZba6lnAPEIt-LC6z09xnQu8MoZAdMfsw03kU6lpia0ke6QFXkyr6l3I6GL'
//             },
//             body: json.encode({
//               'to': token,
//               'message': {
//                 'token': token,
//               },
//               "data": {
//                 "title": "Push Notification $title",
//                 "body": "Firebase  push notification $body"
//               }
//             }),
//           )
//           .then((value) => print(value.body));
//       print('FCM request for web sent!');
//     } catch (e) {
//       print(e);
//     }
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance
//         .getToken(
//             vapidKey:
//                 'BG9k0UFXqotsm408pqNk5D0n4i3YSFWCh3em1gRs48BIEoT_yKZ3FZFsWijINSZiL5krg8jul0eoispoUbm35iY')
//         .then((token) {
//       mtoken = token;
//       print(mtoken);
//       saveToken(token!);
//     });
//   }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   void listenFCM() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       // AndroidNotification? android = message.notification?.android;
//       if (notification != null) {
//         print(
//             'Message also contained a notification: ${message.notification!.body}');
//         Get.defaultDialog(
//             title: "${notification.title}",
//             middleText: "${notification.title}");
//       }
//     });
//   }

//   // void loadFCM() async {
//   //   if (kIsWeb) {
//   //     channel = const NotificationC(
//   //       'high_importance_channel', // id
//   //       'High Importance Notifications', // title
//   //       importance: Importance.high,
//   //       enableVibration: true,
//   //     );

//   //     // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   //     /// Create an Android Notification Channel.
//   //     ///
//   //     /// We use this channel in the `AndroidManifest.xml` file to override the
//   //     /// default FCM channel to enable heads up notifications.
//   //     // await flutterLocalNotificationsPlugin
//   //     //     .resolvePlatformSpecificImplementation<
//   //     //         AndroidFlutterLocalNotificationsPlugin>()
//   //     //     ?.createNotificationChannel(channel);

//   //     /// Update the iOS foreground notification presentation options to allow
//   //     /// heads up notifications.
//   //     await FirebaseMessaging.instance
//   //         .setForegroundNotificationPresentationOptions(
//   //       alert: true,
//   //       badge: true,
//   //       sound: true,
//   //     );
//   //   }
//   // }

// }
