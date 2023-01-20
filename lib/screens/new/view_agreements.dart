import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/screens/signature_page.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../components/topbar.dart';
import '../../utils/styles/app_colors.dart';

class ViewAgreementds extends StatefulWidget {
  @override
  State<ViewAgreementds> createState() => _ViewAgreementdsState();
}

class _ViewAgreementdsState extends State<ViewAgreementds> {
  GlobalKey<SfSignaturePadState> key = GlobalKey();
  bool isLoading = false;
  Uint8List? img;

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  String signUrl = '';

  Future<UploadTask?> uploadFile1(Uint8List? file, String docId) async {
    // idGenerator();
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('signature')
        .child('/${idGenerator()}.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpg',
      // customMetadata: {'picked-file-path': file},
    );

    uploadTask = ref.putData(file, metadata);
    await uploadTask.whenComplete(() => null);
    signUrl = await ref.getDownloadURL();

    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('Agreement').doc(docId).update({
      'agreementStatus': true,
      'signature': signUrl,
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Agreement accepted")));
      // Navigator.pop(context);
      GoRouter.of(context).goNamed(RouteCon.signedagreements);
    });

    return Future.value(uploadTask);
  }

  void UpdateAgreement(String docId) async {
    setState(() {
      isLoading = true;
    });

    ui.Image image = await key.currentState!.toImage();
    final bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = bytedata!.buffer
        .asUint8List(bytedata.offsetInBytes, bytedata.lengthInBytes);
    String e = base64.encode(imageBytes);
    Uint8List decode = base64.decode(e);
    setState(() {
      img = decode;
    });
    uploadFile1(img, docId);
    setState(() {
      isLoading = false;
    });
    print('inside the update Agreement Function');
  }

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
            field = 'sellerId';
            print("pppp $field");
          });
        }
      });
    });
    print("pppp $field");
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
                        // .where('agreementStatus', isEqualTo: true)
                        .where('$field',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('no agreement'));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data!.docs[index];
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpansionTileCard(
                                  leading: Image.network(
                                    data['img'],
                                    fit: BoxFit.cover,
                                  ),
                                  title:
                                      Text("Product Name  : ${data['name']}"),
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Order from ${data['client_name']}",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
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
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  child: Image.network(
                                                    data['client_signature'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'tap on image to view',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            // Text("Product Price ${data['price']}"),
                                            // Text("Product Name ${data['name']}"),
                                            // Text("Product Name ${data['name']}"),
                                          ],
                                        ),
                                        data['signature'] == null
                                            ? Container()
                                            : Column(
                                                children: [
                                                  Text(
                                                    "Seller Name ${data['seller_name']}",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    // height: MediaQuery.of(context).size.height * 0.35,
                                                    // width: MediaQuery.of(context).size.width * 0.3,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showImageViewer(
                                                            context,
                                                            Image.network(data[
                                                                    'signature'])
                                                                .image,
                                                            swipeDismissible:
                                                                false);
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                        child: Image.network(
                                                          data['signature'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'tap on image to view',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  // Text("Product Price ${data['price']}"),
                                                  // Text("Product Name ${data['name']}"),
                                                  // Text("Product Name ${data['name']}"),
                                                ],
                                              ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            data['sellerId'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Container(
                                                    height: 50.0,
                                                    width: 345,
                                                    child: ElevatedButton(
                                                        onPressed:
                                                            data['agreementStatus'] ==
                                                                    true
                                                                ? null
                                                                : () async {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return isLoading
                                                                              ? AlertDialog(
                                                                                  content: CircularProgressIndicator(),
                                                                                )
                                                                              : AlertDialog(
                                                                                  title: const Text('Please put your signature to accept agreement'),
                                                                                  content: Container(
                                                                                    width: 350,
                                                                                    child: SfSignaturePad(
                                                                                      key: key,
                                                                                      backgroundColor: Colors.grey.shade400,
                                                                                      // strokeColor: c,
                                                                                      minimumStrokeWidth: 10,
                                                                                      maximumStrokeWidth: 4,
                                                                                    ),
                                                                                  ),
                                                                                  actions: <Widget>[
                                                                                    Container(
                                                                                      height: 50.0,
                                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                                      child: ElevatedButton(
                                                                                        child: const Text('Confirm'),
                                                                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueDarkColor),
                                                                                        onPressed: () async {
                                                                                          UpdateAgreement(data.id);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                        });
                                                                  },
                                                        // icon: const Icon(Icons.accept),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                data['agreementStatus'] ==
                                                                        true
                                                                    ? AppColors
                                                                        .greyColor
                                                                    : AppColors
                                                                        .greeen),
                                                        child: data['agreementStatus'] ==
                                                                true
                                                            ? Text(
                                                                "Agreement signed")
                                                            : Text(
                                                                "Accept Agreement")),
                                                  )
                                                : Container(),
                                            SizedBox(height: 10),
                                            data['sellerId'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Container(
                                                    height: 50.0,
                                                    width: 345,
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Agreement')
                                                              .doc(data.id)
                                                              .update({
                                                            'agreementStatus':
                                                                false,
                                                            'signature': null,
                                                          }).then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("Agreement canceled")));
                                                          });
                                                        },
                                                        // icon: const Icon(Icons.accept),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .mainBlueColor),
                                                        child: const Text(
                                                            "Cancel Agreement")),
                                                  )
                                                : Container(
                                                    child: data['agreementStatus'] ==
                                                            true
                                                        ? Text(
                                                            "Agreement Accepted")
                                                        : Text(
                                                            "Waiting for approval")),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 50.0,
                                              width: 345,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('Agreement')
                                                        .doc(data.id)
                                                        .delete()
                                                        .then((value) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Agreement canceled")));
                                                    });
                                                  },
                                                  // icon: const Icon(Icons.accept),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .redColor),
                                                  child: const Text(
                                                      "Delete Agreement")),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
