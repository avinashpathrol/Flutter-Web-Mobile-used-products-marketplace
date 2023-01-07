import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/TnC.dart';
import 'package:marketplace/screens/app_colors.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/login_user_product_screen.dart';
import 'package:marketplace/screens/myProfile.dart';
import 'package:marketplace/screens/privacy.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/product_overview.dart';
import 'package:marketplace/screens/user_agreement.dart';
import 'package:share_plus/share_plus.dart';

import '../app_routes/app_route.dart';

class Detail extends StatefulWidget {
  final String pId;
  Detail({super.key, required this.pId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Product? product;

  @override
  void initState() {
    super.initState();
    // getAllProduct();
    getDate();
  }

  getDate() async {
    print("mmmmmmmmmmmm ${widget.pId}");
    await FirebaseFirestore.instance
        .collection('productData')
        // .where('user_Id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs
          .where((element) => element["productId"] == widget.pId)
          .forEach((result) {
        // print("done ${result["productId"]}");
        if (result.exists) {
          setState(() {
            product = Product(
              productId: result['productId'],
              signature: result['signature'],
              seller_name: result['seller_name'],
              userId: result['user_Id'],
              name: result['name'],
              price: result['price'],
              img: result['img'],
              description: result['description'],
              location: result['location'],
              date: result['date'],
            );
          });
        }
      });
    });
    // print(allProducts[0].name);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;

    return product == null
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            // backgroundColor: Color(0xff252B5C),
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
                            style: TextStyle(
                                color: Color.fromARGB(255, 19, 38, 94)),
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
                          style:
                              TextStyle(color: Color.fromARGB(255, 19, 38, 94)),
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
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
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
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        width: 400,
                        child: PageView.builder(
                          //s itemCount: pr.length,
                          //onPageChanged: controller.changeIndicator,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(product!.img),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // indicator

                      SizedBox(
                        height: size.height / 25,
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // children: [
                          //   for (int i = 0;
                          //       i < product.;
                          //       i++)
                          //     indicator(size, false)
                          // ],
                        ),
                      ),

                      SizedBox(
                        height: size.height / 25,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          product!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 35,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\$${product!.price}",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.grey[800],
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                // text: " ${product!.price}% off",
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Colors.green,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 25,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 50,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          product!.description,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 40,
                      ),
                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Seller Name",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 50,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          product!.seller_name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 40,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 80,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          product!.location,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 25,
                      ),
                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 80,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          product!.date,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height / 100,
                      ),

                      Container(
                        height: 50.0,
                        width: 345,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              var url = window.location.href;
                              print(url);
                              Share.share(url);
                            },
                            icon: const Icon(Icons.share),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueDarkColor),
                            label: const Text("Share")),
                      ),
                      SizedBox(
                        height: size.height / 60,
                      ),
                      SizedBox(
                        height: size.height / 14,
                        width: 345,
                        child: Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: Size(345, 50),
                                shadowColor: Color.fromARGB(255, 19, 38, 94),
                              ),
                              onPressed: () {
                                GoRouter.of(context).pushNamed(
                                    RouteCon.productoverview,
                                    extra: product!);
                              },
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: size.height / 20,
                            ),
                            SizedBox(
                              height: size.height / 20,
                            ),
                            // Expanded(
                            //   child: customButtom(size, () {
                            //     GoRouter.of(context).pushNamed(
                            //         RouteCon.productoverview,
                            //         extra: product!);
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: (context) =>
                            //     //             ProductOverview(product!)));
                            //   }, Colors.white, "Buy Now"),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height / 20,
                      ),
                    ]),
              ),
            ),
            bottomNavigationBar: Container(
              height: size.height / 14,
              width: size.width,
              color: Color.fromARGB(255, 19, 38, 94),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 19, 38, 94)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Terms()));
                    },
                    child: Text(
                      'Term and Conditions',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 19, 38, 94)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Privacy()));
                    },
                    child: Text(
                      'Privacy',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 19, 38, 94)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAgreement()));
                    },
                    child: Text(
                      'User Licence Agreement',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget customButtom(Size size, Function function, Color color, String title) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
        alignment: Alignment.center,
        color: color,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: color == Colors.redAccent ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget indicator(Size size, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: isSelected ? size.height / 80 : size.height / 100,
        width: isSelected ? size.height / 80 : size.height / 100,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
    );
  }
}
