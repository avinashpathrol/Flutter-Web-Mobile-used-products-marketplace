import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';

import '../app_routes/app_route.dart';
import '../screens/login_page.dart';
import '../screens/new/myProfile.dart';

class TopBar extends StatelessWidget {
  TopBar({
    Key? key,
  }) : super(key: key);
  int _counter = 0;
  Widget myAppBarIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.black,
              size: 40,
            ),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 5),
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffc32c37),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: Text(
                      _counter.toString(),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        // myAppBarIcon(),
        ChangeIconColorPopupMenu(),
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront,
                    ),
                    Text(
                      "Marketplace",
                      style: TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.add_business,
              ),
              Text(
                "Add Product",
                style: TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
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

                  await FirebaseAuth.instance.signOut();
                  // await FacebookAuth.instance.logOut();
                  GoRouter.of(context).goNamed(RouteCon.login);

                  print('leaving logout function');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const LoginPage()));
                  // } else if (value == 2) {
                  //   print('inside logout function');
                  //   _signOut() async {
                  //     await FirebaseAuth.instance.signOut();
                  //     FacebookAuth.instance.logOut();
                  //   }

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const LoginPage()));
                }
              }),
        )
      ],
    );
  }
}

class ChangeIconColorPopupMenu extends StatefulWidget {
  @override
  ChangeIconColorPopupMenuState createState() {
    return new ChangeIconColorPopupMenuState();
  }
}

class ChangeIconColorPopupMenuState extends State<ChangeIconColorPopupMenu> {
  List<Color> _colors = [
    Colors.indigo,
    Colors.orange,
    Colors.teal,
    Colors.brown,
    Colors.pink
  ];
  String? field;
  int _counter = 0;

  int _ColorIndex = 1;
  _onChanged() {
    int _colorCount = _colors.length;
    setState(() {
      if (_ColorIndex == _colorCount - 1) {
        _ColorIndex = 0;
      } else {
        _ColorIndex += 1;
      }
    });
  }

  changeField() async {
    await FirebaseFirestore.instance
        .collection('Agreement')
        // .where('agreementStatus', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        if (FirebaseAuth.instance.currentUser!.uid == e['buyer_id']) {
          setState(() {
            field = 'buyer_id';
            // print("pppp $field");
          });
        } else if (FirebaseAuth.instance.currentUser!.uid == e['sellerId']) {
          setState(() {
            field = 'sellerId';
            // print("pppp $field");
          });
        }
      });
    });
    print("pppp $field");
  }

  List values = [];

  getNotifications() async {
    await changeField();
    FirebaseFirestore.instance
        .collection('Agreement')
        // .where('agreementStatus', isEqualTo: true)
        .where('$field', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _counter = value.docs.length;
      });
      print(_counter);
      value.docs.forEach((element) {
        if (field == 'buyer_id') {
          values.add(element['agreementTitle'][1].toString());

          // print(element['agreementTitle'].toString().split(' ')[1]);
          // if (element['agreementTitle'].toString().contains('received')) {
          //   element['agreementTitle'].toString().split(' ')[1] =
          //       'waiting for approval';
          //   if (element['agreementTitle'].toString().split(' ')[1] ==
          //       'received') {
          //     values.add('waiting for approval');
          //   } else {

          //    values.add(element['agreementTitle']);
          //   }
          //   // print(element['agreementTitle'].toString().split(' ')[1]);
          // }
        } else if (field == 'sellerId') {
          values.add(element['agreementTitle'][0].toString());
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  PopupMenuButton(
                    offset: Offset(0.0, appBarHeight),
                    icon: Icon(
                      Icons.notifications,
                      // color: _colors[_ColorIndex],
                      color: Colors.black,
                      size: 40,
                    ),
                    itemBuilder: (context) => values
                        .map(
                          (e) => PopupMenuItem(
                            onTap: () {
                              GoRouter.of(context)
                                  .goNamed(RouteCon.showagreement);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.navigate_next,
                                    color: _colors[_ColorIndex]),
                                SizedBox(width: 10.0),
                                Expanded(child: Text("$e")),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    // PopupMenuItem(
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(Icons.home, color: _colors[_ColorIndex]),
                    //       SizedBox(width: 10.0),
                    //       Text("Account"),
                    //     ],
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(Icons.lock, color: _colors[_ColorIndex]),
                    //       SizedBox(width: 10.0),
                    //       Text("Change Password"),
                    //     ],
                    //   ),
                    // ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffc32c37),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            "$_counter",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0),
              // Text("Change Icon Color")
            ],
          ),
        ),
        // Expanded(
        //   child: Center(
        //     child: ElevatedButton(
        //       onPressed: _onChanged,
        //       child: Text(
        //         "Change Icon Color PopupMenuButton",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       // color: Colors.deepPurple,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
