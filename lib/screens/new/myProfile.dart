import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/screens/login_page.dart';

import '../../components/topbar.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileState createState() => _ProfileState();
}

final user = FirebaseAuth.instance.currentUser;
final email = FirebaseAuth.instance.currentUser?.email;

final name = user!.displayName;

final photoUrl = user?.photoURL;

final uid = user?.uid;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: SafeArea(
          child: Column(
        children: [
          //for circle avtar image
          // _getHeader(),
          SizedBox(
            height: 10,
          ),
          _profileName("Your Profile"),
          SizedBox(
            height: 14,
          ),
          // _heading("Personal Details"),
          SizedBox(
            height: 6,
          ),
          _detailsCard(),
          SizedBox(
            height: 10,
          ),
          // _heading("Settings"),
          SizedBox(
            height: 6,
          ),
          _settingsCard(),
          Spacer(),
          logoutButton()
        ],
      )),
    );
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(10.0)),
              shape: BoxShape.circle,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: NetworkImage(
              //         "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"
              //         )
              //         )
              // color: Colors.orange[100],
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileName(String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _heading(String heading) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Text(
        heading,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(Icons.email),
              title: Text("${email}"),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.badge),
              title: GestureDetector(child: Text("View your Products")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.yourProducts);
              },
            ),
            Divider(height: 0.6, color: Colors.black87),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: GestureDetector(child: Text("Pending Agreements")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.showagreement);
              },
            ),
            Divider(height: 0.6, color: Colors.black87),

            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: GestureDetector(child: Text("Signed Agreements")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.signedagreements);
              },
            ),
            // Divider(height: 0.6, color: Colors.black87),

            // ListTile(
            //   leading: Icon(Icons.shopping_bag),
            //   title: GestureDetector(child: Text("View your Agreements")),
            //   onTap: () {
            //     GoRouter.of(context).goNamed(RouteCon.finalscreen);
            //   },
            // ),
            // Divider(
            //   height: 0.6,
            //   color: Colors.black87,
            // ),
            // ListTile(
            //   leading: Icon(Icons.file_download),
            //   title: GestureDetector(child: Text("SignOff")),
            //   onTap: () {
            //     GoRouter.of(context).goNamed(RouteCon.signoff);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: GestureDetector(child: Text("Terms & Condition")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.terms);
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.dashboard_customize),
              title: GestureDetector(child: Text("Privacy")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.privacy);
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.topic),
              title: GestureDetector(child: Text("User License Agreement")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.useragr);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return InkWell(
      onTap: () {},
      child: Container(
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          )),
    );
  }
}
