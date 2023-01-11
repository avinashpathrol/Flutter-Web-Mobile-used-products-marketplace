// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:marketplace/app_routes/app_route.dart';
// import 'package:marketplace/components/topbar.dart';
// import 'package:marketplace/model/product_model.dart';
// import 'package:marketplace/screens/data_controller.dart';
// import 'package:marketplace/screens/pdetails.dart';

// import '../components/bottom_bar.dart';

// class LoginUserProductScreen extends StatelessWidget {
//   LoginUserProductScreen({super.key});

//   final DataController controller = Get.put(DataController());

//   final editPriceValue = TextEditingController();
//   final Size size = Get.size;

//   editProduct(productID, price) {
//     editPriceValue.text = price.toString();
//     Get.bottomSheet(
//       ClipRRect(
//         child: Container(
//           color: Colors.white,
//           height: 200,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Enter new price"),
//                   controller: editPriceValue,
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back();
//                     controller.editProduct(productID, editPriceValue.text);
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.getLoginUserProduct();
//     });

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60.0),
//         child: TopBar(),
//       ),
//       body: GetBuilder<DataController>(
//         builder: (controller) => controller.loginUserData.isEmpty
//             ? Center(
//                 child: Text('😔 NO DATA FOUND PLEASE ADD DATA 😔'),
//               )
//             : ListView.builder(
//                 itemCount: controller.loginUserData.length,
//                 itemBuilder: (context, index) {
//                   Product product = controller.loginUserData[index];
//                   return InkWell(
//                     onTap: () {
//                       controller.loginUserData[index];
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => Detail(
//                                     pId: '',
//                                   )));
//                     },
//                     child: Card(
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 300,
//                             width: 400,
//                             // height: MediaQuery.of(context).size.height * 0.35,
//                             // width: MediaQuery.of(context).size.width * 0.3,
//                             child: Image.network(
//                               controller.loginUserData[index].img!,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Text(
//                                   "Product Name: ${controller.loginUserData[index].name}",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   'Price:\$${controller.loginUserData[index].price.toString()}',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // ElevatedButton(
//                                 //   onPressed: () {
//                                 //     editProduct(
//                                 //         controller
//                                 //             .loginUserData[index].productId,
//                                 //         controller.loginUserData[index].price);
//                                 //   },
//                                 //   child: Text('Edit'),
//                                 // ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     controller.deleteProduct(controller
//                                         .loginUserData[index].productId!);
//                                   },
//                                   child: Text('Delete'),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     GoRouter.of(context).goNamed(
//                                         RouteCon.editproduct,
//                                         extra: controller.loginUserData[index]);

//                                     print(
//                                         "dadada ${controller.loginUserData[index].name}");
//                                     print(
//                                         "hello ${controller.loginUserData[index].docId}");
//                                     // controller.deleteProduct(controller
//                                     //     .loginUserData[index].productId);
//                                   },
//                                   child: Text('Edit'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//       bottomNavigationBar: BottomBar(size: size),
//     );
//   }
// }
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

class LoginUserProductScreen extends StatelessWidget {
  LoginUserProductScreen({super.key});

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
        stream: FirebaseFirestore.instance
            .collection("productData")
            .where("user_Id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                controller.deleteProduct(
                                    controller.loginUserData[index].productId!);
                              },
                              child: Text('Delete'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).goNamed(
                                    RouteCon.editproduct,
                                    extra: controller.loginUserData[index]);
                              },
                              child: Text('Edit'),
                            ),
                          ),
                        ],
                      )
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
