import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:marketplace/model/Agreement.dart';

import '../components/topbar.dart';
import '../utils/styles/app_colors.dart';
import 'data_controller.dart';

class SignOff extends StatelessWidget {
  late final Agreement agreement;
  SignOff(this.agreement);
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff252B5C),
        child: SafeArea(
          child: GetBuilder<DataController>(
            builder: (value) {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: TopBar(),
                ),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // CircleAvatar(
                      //     radius: 70, backgroundImage: AssetImage('images/arslan.jpg')),
                      Text(
                        'Final Sign-Off',
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
                      GestureDetector(
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            title: Text(
                              'Agree',
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          updateAgree();
                        },
                      ),
                      GestureDetector(
                        child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: ListTile(
                              title: Text(
                                'Disagree',
                                style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                ),
                              ),
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  // title: const Text('AlertDialog Title'),
                                  content: const Text(
                                      'To confirm, click confirm button'),

                                  actions: <Widget>[
                                    Container(
                                      height: 50.0,
                                      width: 345,
                                      child: ElevatedButton(
                                        child: const Text('Confirm'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.blueDarkColor),
                                        onPressed: () {
                                          updateDisagree();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      // onTap: () {
                      //   updateDisagree();
                      // },

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
              );
            },
          ),
        ));
  }

  updateAgree() async {
    print('Inside the agree function');
    // var auth;
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final User? user = auth.currentUser;
    // final uid = user?.uid;
    // print('user ID fetched ${uid}');

    FirebaseFirestore.instance.collection('agreementStatus').add({
      'approved': 'YES',
      'cancelled': 'NO',
      'user_Id': uid,
      'productId': agreement.productId
    });
  }

  updateDisagree() async {
    print('Inside the agree function');
    // var auth;
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final User? user = auth.currentUser;
    // final uid = user?.uid;
    // print('user ID fetched ${uid}');

    FirebaseFirestore.instance.collection('agreementStatus').add({
      'approved': 'NO',
      'cancelled': 'YES',
      'user_Id': uid,
      'productId': agreement.productId
    });
  }
}
