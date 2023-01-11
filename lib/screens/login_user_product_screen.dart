import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/components/topbar.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/pdetails.dart';

import '../components/bottom_bar.dart';

class LoginUserProductScreen extends StatelessWidget {
  LoginUserProductScreen({super.key});

  final DataController controller = Get.put(DataController());

  final editPriceValue = TextEditingController();
  final Size size = Get.size;

  editProduct(productID, price) {
    editPriceValue.text = price.toString();
    Get.bottomSheet(
      ClipRRect(
        child: Container(
          color: Colors.white,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter new price"),
                  controller: editPriceValue,
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.editProduct(productID, editPriceValue.text);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getLoginUserProduct();
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: GetBuilder<DataController>(
        builder: (controller) => controller.loginUserData.isEmpty
            ? Center(
                child: Text('😔 NO DATA FOUND PLEASE ADD DATA 😔'),
              )
            : ListView.builder(
                itemCount: controller.loginUserData.length,
                itemBuilder: (context, index) {
                  Product product = controller.loginUserData[index];
                  return InkWell(
                    onTap: () {
                      controller.loginUserData[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(
                                    pId: '',
                                  )));
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
                              controller.loginUserData[index].img,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Product Name: ${controller.loginUserData[index].name}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Price:\$${controller.loginUserData[index].price.toString()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
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
                                    controller.deleteProduct(controller
                                        .loginUserData[index].productId);
                                  },
                                  child: Text('Delete'),
                                ),
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
