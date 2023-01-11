import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/save_pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../components/bottom_bar.dart';
import '../components/topbar.dart';

class ShowAgreement extends StatelessWidget {
  late final Agreement agreement;
  ShowAgreement(this.agreement);

  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;
    // final controller = Get.put(ItemDetailController());

    // controller.getItemDetails(id);

    return Container(
      color: Color(0xff252B5C),
      child: SafeArea(
        child: GetBuilder<DataController>(builder: (value) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: TopBar(),
            ),
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height / 3.5,
                        width: size.width,
                        child: PageView.builder(
                          //s itemCount: pr.length,
                          //onPageChanged: controller.changeIndicator,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(agreement.img),
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
                          agreement.name,
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
                                text: "\$${agreement.price}",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.grey[800],
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                // text: " ${product.price}% off",
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
                          agreement.description,
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
                        height: size.height / 50,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          agreement.location,
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
                          "Buyer Name",
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
                          agreement.client_name,
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
                          "Client Location",
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
                          agreement.client_location,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 40,
                      ),

                      SizedBox(
                        height: size.height / 80,
                      ),

                      SizedBox(
                        width: size.width / 1.2,
                        child: Text(
                          agreement.location,
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
                          agreement.date,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: Text("See Reviews"),
                      //   trailing: Icon(Icons.arrow_forward_ios),
                      //   leading: Icon(Icons.star),
                      // ),

                      SizedBox(
                        height: size.height / 100,
                      ),
                      SizedBox(
                        height: size.height / 14,
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: customButtom(size, () {
                                GoRouter.of(context).pushNamed(RouteCon.signoff,
                                    extra: agreement);
                              }, Colors.white, "Final Sign Off"),
                            ),
                            Expanded(
                              child: customButtom(size, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SaveBtnBuilder(agreement)));
                              }, Colors.white, "Export"),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),

            // bottomNavigationBar: SizedBox(
            //   height: size.height / 14,
            //   width: size.width,
            //   child: Row(
            //     children: [
            //       // Expanded(
            //       //   child: customButtom(
            //       //     size,
            //       //     () {
            //       //       // if (controller.isAlreadyAvailable) {
            //       //       //   Get.to(() => CartScreen());
            //       //       // } else {
            //       //       //   controller.addItemsToCart();
            //       //       // }
            //       //     },
            //       //     Colors.redAccent,
            //       //     // product.isAlreadyAvailable
            //       //         ? "Go to Cart"
            //       //         : "Add to Cart",
            //       //   ),
            //       // ),
            //       Expanded(
            //         child: customButtom(size, () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ProductOverview(product)));
            //         }, Colors.white, "Buy Now"),
            //       ),
            //     ],
            //   ),
            // ),
            bottomNavigationBar: BottomBar(size: size),
          );
        }),
      ),
    );
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

void printff() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World!'),
      ),
    ),
  );

  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
}

// Future<void> printffn() async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Center(
//         child: pw.Text('Hello World!'),
//       ),
//     ),
//   );

//   final file = File('example.pdf');
//   await file.writeAsBytes(await pdf.save());
// }
