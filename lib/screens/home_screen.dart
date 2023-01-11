import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/components/topbar.dart';
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

import '../components/bottom_bar.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("productData").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.length == 0) {
            return Center(
                child: Text(
              "NO DATA / Add some product's".toUpperCase(),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ));
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
                      params: {"productId": loginUserData[index].productId!});
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
                          loginUserData[index].img!,
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
      bottomNavigationBar: BottomBar(size: size),
    );
  }
}
