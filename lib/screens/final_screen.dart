import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/new/myProfile.dart';

import '../components/bottom_bar.dart';
import '../components/topbar.dart';

class FinalScreen extends StatelessWidget {
  FinalScreen({super.key});

  final DataController controller = Get.put(DataController());

  final editPriceValue = TextEditingController();
  final Size size = Get.size;
  var auth;
  String approved = "NO";
  String cancelled = "NO";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getAgreementData();
    });
//   void updateAgreementStatus() async {
//   var auth;
//   final User? user = auth.currentUser;
//   final uid = user?.uid;
//       var res = FirebaseFirestore.instance.collection('Agreement').add({

//       'user_Id': controller.loginAgreementData,

//     }).then((value) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Agreement Uploaded')));
// }
// }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: GetBuilder<DataController>(
        builder: (controller) => controller.loginAgreementData.isEmpty
            ? Center(
                child: Text('😔 NO DATA FOUND PLEASE ADD DATA 😔'),
              )
            : ListView.builder(
                itemCount: controller.loginAgreementData.length,
                itemBuilder: (context, index) {
                  Agreement agreement = controller.loginAgreementData[index];
                  return InkWell(
                    onTap: () {
                      controller.loginAgreementData[index];
                      GoRouter.of(context)
                          .pushNamed(RouteCon.showagreement, extra: agreement);
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
                              controller.loginAgreementData[index].img,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Product Name: ${controller.loginAgreementData[index].name}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Price: ${controller.loginAgreementData[index].price.toString()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // ElevatedButton(
                                //   onPressed: () {
                                //     editProduct(
                                //         controller
                                //             .loginUserData[index].productId,
                                //         controller.loginUserData[index].price);
                                //   },
                                //   child: Text('Edit'),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    // controller.deleteProduct(controller
                                    //     .loginAgreementData[index]
                                    //     .agreementId);

                                    print('Inside the agree function');
                                    // var auth;
                                    // final uid = FirebaseAuth.instance.currentUser!.uid;
                                    // final User? user = auth.currentUser;
                                    // final uid = user?.uid;
                                    // print('user ID fetched ${uid}');

                                    FirebaseFirestore.instance
                                        .collection('agreementCancel')
                                        .add({
                                      'approved': 'NO',
                                      'cancelled': 'YES',
                                      'user_Id': uid,
                                      'productId': controller
                                          .loginAgreementData[index].productId
                                    });
                                  },
                                  child: Text('CANCEL THE AGREEMENT'),
                                ),

                                Text(
                                    'You will have to pay a sum ${"xyz"} fee if you cancel this agreement')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomBar(size: size),
    );
  }
}
