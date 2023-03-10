import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../components/topbar.dart';
import '../../utils/styles/app_colors.dart';

class SignedAgreementds extends StatefulWidget {
  @override
  State<SignedAgreementds> createState() => _SignedAgreementdsState();
}

class _SignedAgreementdsState extends State<SignedAgreementds> {
  GlobalKey<SfSignaturePadState> key = GlobalKey();
  String? field;

  changeField() {
    FirebaseFirestore.instance
        .collection('Agreement')
        // .where('agreementStatus', isEqualTo: true)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        if (FirebaseAuth.instance.currentUser!.uid == e['buyer_id']) {
          setState(() {
            field = 'buyer_id';
            print("pppp $field");
          });
        } else {
          setState(() {
            field = 'buyer_id';
            print("pppp $field");
          });
        }
      });
    });
    print("signed $field");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      body: field == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Agreement')
                        .where('agreementStatus', isEqualTo: true)
                        .where('$field',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('no agreement'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data!.docs[index];
                          return ExpansionTileCard(
                            title: Text("${data['name']}"),
                            baseColor: Colors.cyan[50],
                            expandedColor: Colors.red[50],
                            leading: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              // height: MediaQuery.of(context).size.height * 0.35,
                              // width: MediaQuery.of(context).size.width * 0.3,
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  data['img'],
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.height * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Column(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     // Text("${data['price']}"),
                                          //     // Text("Product Name ${data['name']}"),
                                          //     // Text("Product Name ${data['name']}"),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          // SizedBox(height: 5),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            // height: MediaQuery.of(context).size.height * 0.35,
                                            // width: MediaQuery.of(context).size.width * 0.3,
                                            child: GestureDetector(
                                              onTap: () {
                                                showImageViewer(
                                                    context,
                                                    Image.network(data[
                                                            'client_signature'])
                                                        .image,
                                                    swipeDismissible: false);
                                              },
                                              child: ClipRRect(
                                                // borderRadius: BorderRadius.circular(20),
                                                child: Image.network(
                                                  data['client_signature'],
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "${data['client_name']} signature",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            // height: MediaQuery.of(context).size.height * 0.35,
                                            // width: MediaQuery.of(context).size.width * 0.3,
                                            child: GestureDetector(
                                              onTap: () {
                                                showImageViewer(
                                                    context,
                                                    Image.network(
                                                            data['signature'])
                                                        .image,
                                                    swipeDismissible: false);
                                              },
                                              child: ClipRRect(
                                                // borderRadius: BorderRadius.circular(20),
                                                child: Image.network(
                                                  data['signature'],
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${data['seller_name']} signature",
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(height: 10),
                                          Container(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  // controller.loginAgreementData[index];
                                                  Agreement agreement =
                                                      Agreement(
                                                          docId: data.id,
                                                          name: data['name'], //
                                                          description: data[
                                                              'description'], //
                                                          price:
                                                              data['price'], //
                                                          signature: data[
                                                              'signature'], //
                                                          location: data[
                                                              'location'], //
                                                          user_Id:
                                                              data['sellerId'],
                                                          img: data['img'],
                                                          date: data['date'],
                                                          agreementId:
                                                              "data['agreementId']",

                                                          ///
                                                          client_signature: data[
                                                              'client_signature'],
                                                          client_name: data[
                                                              'client_name'],
                                                          client_location: data[
                                                              'client_location'],
                                                          client_date: data[
                                                              'client_date'],
                                                          account_no: data[
                                                              'account_No'],
                                                          institution_no: data[
                                                              'institution_No'],
                                                          transit_no: data[
                                                              'transit_No'],
                                                          productId:
                                                              data['productId'],
                                                          seller_name: data[
                                                              'seller_name'],
                                                          partial_pay: data[
                                                              'partial_pay']);
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                          RouteCon.makepdf,
                                                          extra: agreement);
                                                  // print(agreement);
                                                  // agreement.
                                                  // FirebaseFirestore.instance
                                                  //     .collection('Agreement')
                                                  //     .doc(data.id)
                                                  //     .delete()
                                                  //     .then((value) {
                                                  //   ScaffoldMessenger.of(context)
                                                  //       .showSnackBar(SnackBar(
                                                  //           content: Text(
                                                  //               "Agreement canceled")));
                                                  // });
                                                },
                                                // icon: const Icon(Icons.accept),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.redColor),
                                                child: const Text(
                                                    "Got to the final signOFF Screen")),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
