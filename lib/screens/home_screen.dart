import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/components/topbar.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:http/http.dart' as http;

import '../components/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final DataController controller = Get.put(DataController());
  final Size size = Get.size;
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

  // late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // NotificationService ns = NotificationService();
  String? _token;
  Stream<String>? _tokenStream;
  int notificationCount = 0;

  void setToken(String token) {
    print('FCM TokenToken: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BG9k0UFXqotsm408pqNk5D0n4i3YSFWCh3em1gRs48BIEoT_yKZ3FZFsWijINSZiL5krg8jul0eoispoUbm35iY')
        .then((v) {
      print("vvvv $v");
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'deviceToken': v});
      setToken(v!);
    });
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen(setToken);
    messageListener(context);
    // getToken();
    // ns.requestPermission();

    // ns.loadFCM();

    // ns.getToken();
    // ns.listenFCM();

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.getLoginUserProduct();
    // });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                // sendPushMessageToWeb();
              },
              child: Text('okkkkkk')),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("productData")
                  // .where('user_Id',
                  //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.length == 0) {
                  return Center(
                      child: Text(
                    "NO DATA / Add some product's".toUpperCase(),
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ));
                }
                List<Product> loginUserData = [];
                snapshot.data!.docs.forEach((result) {
                  loginUserData.add(
                    Product(
                      productId: result['productId'],
                      // signature: result['signature'],
                      seller_name: result['seller_name'],
                      userId: result['user_Id'],
                      name: result['name'],
                      price: result['price'],
                      img: result['img'],
                      description: result['description'],
                      location: result['location'],
                      date: result['date'],
                    ),
                  );
                });
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Product product = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context).goNamed(RouteCon.productdetail,
                            params: {
                              "productId": loginUserData[index].productId!
                            });
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              height: 300,
                              width: 400,
                              // height: MediaQuery.of(context).size.height * 0.35,
                              // width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.network(
                                loginUserData[index].img!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Product Name: ${loginUserData[index].name}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price:\$${loginUserData[index].price.toString()}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 ProductOverview(product)));
                                  //   },
                                  //   child: Text(''),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(size: size),
    );
  }
}

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

sendPushMessageToWeb(String token, String title, String body) async {
  if (token.isEmpty) {
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
                'key=AAAAuthZrXA:APA91bE5bHEQ32MzLhD-R9rZDYMTo4Hzhhw3-rhOo5oHdpH46fPFWuNwT-ougm4Bau4JkxcHvsQYzQsNPsZba6lnAPEIt-LC6z09xnQu8MoZAdMfsw03kU6lpia0ke6QFXkyr6l3I6GL'
          },
          body: json.encode({
            'to': token,
            'message': {
              'token': token,
            },
            "notification": {"title": "$title", "body": "$body"}
          }),
        )
        .then((value) => print(value.body));
    print('FCM request for web sent!');
  } catch (e) {
    print(e);
  }
}
