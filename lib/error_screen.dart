import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "404",
              style: TextStyle(fontSize: 70),
            ),
            Text(
              "page not found",
              style: TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
