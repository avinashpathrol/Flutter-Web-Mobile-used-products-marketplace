import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class saveData extends StatelessWidget {
  CollectionReference userdata = FirebaseFirestore.instance.collection("test");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Enter a note"),
          ),
          ElevatedButton(
              onPressed: () async {
                await userdata.add({'name': 'shahahshs', 'price': '1221'}).then(
                    (value) => print("user added"));
              },
              child: Text('submit data'))
        ],
      ),
    );
  }
}
