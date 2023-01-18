import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:printing/printing.dart';

////////////////////////////////////////////////////
void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyB_OL66ttRCjF-3ZgyXt4OhbQ111cig6Z4',
          appId: '1:802493672816:web:2cd31c09b8600bee7cb3b5',
          messagingSenderId: '802493672816',
          projectId: 'eagreeinc',
          storageBucket: 'eagreeinc.appspot.com'));

  await FacebookAuth.instance.webAndDesktopInitialize(
    appId: "490007376581345",
    cookie: true,
    xfbml: true,
    version: "v15.0",
  );
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // User? firebaseUser = FirebaseAuth.instance.currentUser;
    // Widget widget;
    // if (firebaseUser != null) {
    //   // print(firebaseUser.email);
    //   widget = HomeScreen();
    // } else {
    //   widget = LoginPage();
    // }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'eagree',
      routerConfig: AppRoutes().router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'eagree',
    //   // routerConfig: AppRoutes().router,
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: NotificationPage(),
    // );
  }
}

// Entry point for the example application.
class PushNotificationApp extends StatefulWidget {
  static const routeName = "/firebase-push";

  @override
  _PushNotificationAppState createState() => _PushNotificationAppState();
}

class _PushNotificationAppState extends State<PushNotificationApp> {
  @override
  void initState() {
    getPermission();
    // messageListener(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // messageListener(context);
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print('android firebase initiated');
          return NotificationPage();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void messageListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
        showDialog(
            context: context,
            builder: ((BuildContext context) {
              return DynamicDialog(
                  title: message.notification!.title,
                  body: message.notification!.body);
            }));
      }
    });
  }
}

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<NotificationPage> {
  // String? _token;
  // Stream<String>? _tokenStream;
  int notificationCount = 0;
  String? _token;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  void getToken() async {
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                "BG9k0UFXqotsm408pqNk5D0n4i3YSFWCh3em1gRs48BIEoT_yKZ3FZFsWijINSZiL5krg8jul0eoispoUbm35iY")
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase push notification'),
        ),
        body: Container(
          child: Center(
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ListTile(
                title: Center(
                  child: OutlinedButton.icon(
                    label: Text('Push Notification',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    onPressed: () {
                      sendPushMessageToWeb();
                    },
                    icon: Icon(Icons.notifications),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  //send notification
  sendPushMessageToWeb() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer AAAAuthZrXA:APA91bE5bHEQ32MzLhD-R9rZDYMTo4Hzhhw3-rhOo5oHdpH46fPFWuNwT-ougm4Bau4JkxcHvsQYzQsNPsZba6lnAPEIt-LC6z09xnQu8MoZAdMfsw03kU6lpia0ke6QFXkyr6l3I6GL'
        },
        body: json.encode({
          "to": _token,
          "message": {
            'token': _token,
          },
          "notification": {
            "title": "Push Notification",
            "body": "Firebase  push notification"
          }
        }),
      )
          .then((value) {
        print(value.statusCode);
        showDialog(
            context: context,
            builder: (c) {
              return SimpleDialog(
                title: Text("sentttttt"),
              );
            });
        DynamicDialog(
          title: "aaaa",
          body: value.body,
        );
      });
      print('FCM request for web sent!');
    } catch (e) {
      print(e);
    }
  }
}

//push notification dialog for foreground
class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        OutlinedButton.icon(
            label: Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close))
      ],
      content: Text(widget.body),
    );
  }
}
