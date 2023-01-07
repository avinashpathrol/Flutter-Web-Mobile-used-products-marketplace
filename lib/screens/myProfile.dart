import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/screens/login_page.dart';

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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/eagree.png',
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 19, 38, 94)),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return Color.fromARGB(255, 19, 38, 94)
                            .withOpacity(0.04);
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed))
                        return Color.fromARGB(255, 19, 38, 94)
                            .withOpacity(0.12);
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () {
                  GoRouter.of(context).goNamed(RouteCon.home);

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Column(children: [
                  Icon(
                    Icons.storefront,
                  ),
                  TextButton(
                    child: Text(
                      "Marketplace",
                      style: TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
                    ),
                    onPressed: () => {},
                  ),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 19, 38, 94)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Color.fromARGB(255, 19, 38, 94).withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Color.fromARGB(255, 19, 38, 94).withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                GoRouter.of(context).goNamed(RouteCon.addproduct);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ProductImagePicker()));
              },
              child: Column(children: [
                Icon(
                  Icons.add_business,
                ),
                TextButton(
                  child: Text(
                    "Add Product",
                    style: TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
                  ),
                  onPressed: () => {},
                ),
              ]),
            ),
          ),
          PopupMenuButton(
              // icon: Icon(Icons.access_alarm),
              iconSize: 30,
              color: Color.fromARGB(255, 215, 215, 215),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Log Out'),
                    ),
                  ],
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                } else if (value == 1) {
                  print('inside logout function');
                  _signOut() async {
                    await FirebaseAuth.instance.signOut();
                    FacebookAuth.instance.logOut();
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else if (value == 2) {
                  print('inside logout function');
                  _signOut() async {
                    await FirebaseAuth.instance.signOut();
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Column(
          children: [
            //for circle avtar image
            _getHeader(),
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
      ),
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
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: GestureDetector(child: Text("View your Agreements")),
              onTap: () {
                GoRouter.of(context).goNamed(RouteCon.finalscreen);
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
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
