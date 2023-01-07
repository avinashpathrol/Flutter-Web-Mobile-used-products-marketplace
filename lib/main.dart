import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/screens/get_started_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/main_screen.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
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
  }
}
