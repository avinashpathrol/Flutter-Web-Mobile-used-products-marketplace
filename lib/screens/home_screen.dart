import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/TnC.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/login_user_product_screen.dart';
import 'package:marketplace/screens/myProfile.dart';
import 'package:marketplace/screens/pdetails.dart';
import 'package:marketplace/screens/privacy.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/product_overview.dart';
import 'package:marketplace/screens/user_agreement.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DataController controller = Get.put(DataController());

  final editPriceValue = TextEditingController();
  final Size size = Get.size;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getLoginUserProduct();
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                onSelected: (value) async {
                  if (value == 0) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
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
                })
          ],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("productData").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.data!.docs.length == 0) {
              return Text("NO DATA");
            }
            List<Product> loginUserData = [];
            snapshot.data!.docs.forEach((result) {
              loginUserData.add(
                Product(
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
                ),
              );
            });
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // Product product = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () {
                    GoRouter.of(context).goNamed(RouteCon.productdetail,
                        params: {"productId": loginUserData[index].productId});
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: 400,
                          // height: MediaQuery.of(context).size.height * 0.35,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.network(
                            loginUserData[index].img,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Product Name: ${loginUserData[index].name}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Price:\$${loginUserData[index].price.toString()}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 ProductOverview(product)));
                              //   },
                              //   child: Text(''),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
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
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 19, 38, 94)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserAgreement()));
                },
                child: Text(
                  'User Licence Agreement',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
