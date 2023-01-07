import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/myProfile.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                        style:
                            TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // CircleAvatar(
              //     radius: 70, backgroundImage: AssetImage('images/arslan.jpg')),
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in mauris sit amet leo malesuada tincidunt. Sed arcu nisl, tempor at ex id, bibendum porta dolor. Integer vitae consequat magna. Morbi ultrices, ligula quis luctus consequat, lacus quam ultrices quam, vitae vestibulum diam quam a augue. Donec in consequat augue, non luctus libero. Sed tempus aliquet aliquam. In vehicula enim elementum nisi euismod, at ullamcorper tellus consectetur. Nam ut risus a ante volutpat posuere. Cras quis euismod nibh.',
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
    );
  }
}
