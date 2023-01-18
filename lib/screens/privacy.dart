import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/components/topbar.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/new/myProfile.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: TopBar(),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // CircleAvatar(
                //     radius: 70, backgroundImage: AssetImage('images/arslan.jpg')),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Privacy',
                  style: TextStyle(
                      fontFamily: 'Pacifico',
                      color: Color.fromARGB(255, 19, 38, 94),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                // Text(
                //   '',
                //   style: TextStyle(
                //       fontFamily: 'SourceSansPro',
                //       letterSpacing: 2.5,
                //       color: Color(0xfff07b3f),
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold),
                // ),
                SizedBox(
                  height: 20,
                  width: 150,
                  child: Divider(
                    color: Color.fromARGB(255, 19, 38, 94),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    // leading: Icon(
                    //   Icons.phone,
                    //   color: Color(0xfff07b3f),
                    // ),
                    title: Text(
                      'eAgree Inc. ("we," "us," or "our") is committed to protecting the privacy of our users ("user," "you," or "your"). This Privacy Policy explains how we collect, use, and share information about you when you use our websites, including www.eagree.co (the "Site"), and our mobile applications (the "App"), as well as any other features, technologies, or functionalities offered on or through the Site or the App (collectively, the "Services"). \n\nBy using the Services, you agree to the collection, use, and sharing of your information as described in this Privacy Policy. If you do not agree with our policies and practices, do not use the Services.\n\nWe may change our policies and practices from time to time, and we encourage you to review this Privacy Policy whenever you access the Services. If we make any changes, we will post the revised Privacy Policy on this page and update the "Last Updated" date at the top of this Privacy Policy.\n\n1.	Information We Collect About You \n\nWe collect information about you when you use the Services, including the following:•	Personal Information: We may collect personal information about you, such as your name, email address, phone number, and location. We may also collect other personal information, such as your age, gender, and interests.\n\n•	Usage Information: We may collect information about how you use the Services, including the type of device you use, your devices unique identifier, the IP address of your device, your operating system, the type of internet browser you use, and the pages you visit on the Site.\n\n•	Location Information: We may collect information about your location when you use the Services. We may use this information to customize the Services for you and to provide you with location-based features and content.\n\n•	Information Collected Automatically: We may collect information about you automatically when you use the Services, including information about your interactions with the Services and information about your device and internet connection. This information may include device and usage data, such as your IP address, browser type and language, access times, pages viewed, and the pages you visit before and after using the Services.\n\n•	Information From Third Parties: We may receive information about you from third parties, such as other users, partners, and public sources.\n\n2.	How We Use Your InformationWe may use the information we collect about you for the following purposes:\n\n•	To provide and improve the Services: We may use your information to provide and improve the Services, including to personalize your experience, to send you updates and newsletters, and to respond to your comments and questions.\n\n•	To communicate with you: We may use your information to communicate with you about the Services, including to send you updates, newsletters, and other information.•	To protect the security and integrity of the Services: We may use your information to protect the security and integrity of the Services and to enforce our policies.\n\n•	For research and analytics: We may use your information for research and analytics purposes, to understand how users interact with the Services and to improve the Services.\n\n•	For legal purposes: We may use your information as needed to comply with our legal obligations, to resolve disputes, and to enforce our agreements.\n\n3.	How We Share Your Information\n\nWe may share your information with third parties in the following circumstances:\n\n•	With Service Providers: We may share your information with service providers that perform services on our behalf, such as hosting and maintenance, analytics, marketing, and customer service. These service providers are required to protect your information and may use your information only as directed',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                // Card(
                //   margin: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.email,
                //       color: Color(0xfff07b3f),
                //     ),
                //     title: Text(
                //       'ch.arslan.95@gmail.com',
                //       style: TextStyle(
                //         fontFamily: 'SourceSansPro',
                //         color: Color(0xfff07b3f),
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
