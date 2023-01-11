import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';

import '../screens/TnC.dart';
import '../screens/privacy.dart';
import '../screens/user_agreement.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 14,
      width: size.width,
      color: Color.fromARGB(255, 19, 38, 94),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 38, 94)),
            onPressed: () {
              GoRouter.of(context).goNamed(RouteCon.terms);
            },
            child: Text(
              'Term and Conditions',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 38, 94)),
            onPressed: () {
              GoRouter.of(context).goNamed(RouteCon.privacy);
            },
            child: Text(
              'Privacy',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 38, 94)),
            onPressed: () {
              GoRouter.of(context).goNamed(RouteCon.useragr);
            },
            child: Text(
              'User Licence Agreement',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
