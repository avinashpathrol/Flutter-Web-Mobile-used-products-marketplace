import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';

import '../app_routes/app_route.dart';
import '../screens/login_page.dart';
import '../screens/myProfile.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            GoRouter.of(context).goNamed(RouteCon.home);
          },
          child: Image.asset(
            'assets/images/eagree.png',
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
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
          padding: const EdgeInsets.all(0.0),
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
        Theme(
          data: Theme.of(context).copyWith(cardColor: Colors.black),
          child: PopupMenuButton(

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
              onSelected: (value) async {
                if (value == 0) {
                  GoRouter.of(context).goNamed(RouteCon.profile);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Profile()));
                } else if (value == 1) {
                  print('inside logout function');
                  _signOut() async {
                    await FirebaseAuth.instance.signOut();
                  }

                  print('leaving logout function');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else if (value == 2) {
                  print('inside logout function');
                  _signOut() async {
                    await FirebaseAuth.instance.signOut();
                    FacebookAuth.instance.logOut();
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
              }),
        )
      ],
    );
  }
}
