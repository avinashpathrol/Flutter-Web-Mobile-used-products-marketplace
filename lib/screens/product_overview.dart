import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/TnC.dart';
import 'package:marketplace/screens/app_colors.dart';
import 'package:marketplace/screens/app_styles.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/final_screen.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/login_user_product_screen.dart';
import 'package:marketplace/screens/myProfile.dart';
import 'package:marketplace/screens/privacy.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/user_agreement.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import 'package:uuid/uuid.dart';

enum SingingCharacter { directDeposit, etransfer }

class ProductOverview extends StatefulWidget {
  late final Product product;
  late final String pId;
  late final Agreement agreement;
  ProductOverview(this.product, {super.key});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  bool isVisible = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UploadTask?> uploadFile1(Uint8List? file) async {
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

    final User? user = auth.currentUser;
    final uid = user?.uid;
    var res = FirebaseFirestore.instance.collection('Agreement').add({
      'name': widget.product.name,
      'seller_name': widget.product.seller_name,
      'price': widget.product.price,
      'description': widget.product.description,
      'date': widget.product.date,
      'location': widget.product.location,
      'signature': widget.product.signature,
      'img': widget.product.img,
      'user_Id': uid,
      'client_name': _itemNameController.text,
      'client_date': _itemDateController.text,
      'client_location': _itemLocationController.text,
      'client_signature': signUrl,
      'account_No': _itemAccountNoController.text,
      'institution_No': _itemInstitutionNoController.text,
      'transit_No': _itemTransitNoController.text,
      'partial_pay': _itemPartialPayController.text,
      'productId': widget.product.productId
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Agreement Uploaded')));
      // sendPushMessage();
      setState(() {
        isLoading = false;
      });
      GoRouter.of(context).pushNamed(RouteCon.finalscreen);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: ((context) => FinalScreen())));
    });

    return Future.value(uploadTask);
  }

  final DataController controller = Get.put(DataController());

  TextEditingController _itemNameController = TextEditingController();

  TextEditingController _itemDescriptionController = TextEditingController();

  TextEditingController _itemPriceController = TextEditingController();

  TextEditingController _deviceTokenController = TextEditingController();

  TextEditingController _itemDateController = TextEditingController();

  TextEditingController _itemLocationController = TextEditingController();

  TextEditingController _itemSignatureController = TextEditingController();

  TextEditingController _itemAccountNoController = TextEditingController();

  TextEditingController _itemInstitutionNoController = TextEditingController();

  TextEditingController _itemTransitNoController = TextEditingController();

  TextEditingController _itemPartialPayController = TextEditingController();

  // TextEditingController _institutionnoController = TextEditingController();

  TextEditingController _signatureController = TextEditingController();

  bool isLoading = false;
  GlobalKey<SfSignaturePadState> key = GlobalKey();
  double min = 4.0;
  Uuid? v;
  Uint8List? img;
  List<Color> colors = [Colors.black];
  Color? c;
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  String signUrl = '';
  String psignUrl = '';

  // int _value = 0;
  String paymentType = '';

  // SingingCharacter? _character = SingingCharacter.lafayette;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getLoginUserProduct();
    });
    final Size size = Get.size;
    // final controller = Get.put(ItemDetailController());

    // controller.getItemDetails(id);

    return Container(
      color: Color(0xff252B5C),
      child: SafeArea(
        child: GetBuilder<DataController>(builder: (value) {
          return Scaffold(
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
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
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
                            style: TextStyle(
                                color: Color.fromARGB(255, 19, 38, 94)),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
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
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                height: 300,
                                width: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(widget.product.img),
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
                          widget.product.name,
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
                            // text: "${widget.product.price}",
                            children: [
                              TextSpan(
                                text: "\$${widget.product.price}",
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
                          widget.product.description,
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
                          widget.product.location,
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
                          widget.product.date,
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
                        height: size.height / 80,
                      ),
                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Authorization / Fees",
                          textAlign: TextAlign.center,
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
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Signature',
                          textAlign: TextAlign.start,
                          style: ralewayStyle.copyWith(
                              fontSize: 25.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Caramel'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: 350,
                          child: SfSignaturePad(
                            key: key,
                            backgroundColor: Colors.grey.shade400,
                            strokeColor: c,
                            minimumStrokeWidth: 10,
                            maximumStrokeWidth: min,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 290),
                        child: Text(
                          'Name',
                          textAlign: TextAlign.start,
                          style: ralewayStyle.copyWith(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 50.0,
                          width: 345,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            // keyboardType: TextInputType.multiline,
                            // minLines: 2, // <-- SEE HERE
                            // maxLines: 2,
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Client Name Required'
                                  : null;
                            },
                            controller: _itemNameController,

                            // onSaved: (value) {
                            //   productData['Description'] = value!;
                            // },
                            // controller: _emailTextController,
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              border: OutlineInputBorder(),

                              // prefixIcon: IconButton(
                              //     onPressed: () {},
                              //     icon: Image.asset(AppIcons.emailIcon)),
                              contentPadding:
                                  const EdgeInsets.only(top: 5.0, left: 12.0),
                              hintText: 'Name',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: size.height / 100,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 300),
                        child: Text(
                          'Date',
                          textAlign: TextAlign.start,
                          style: ralewayStyle.copyWith(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 50.0,
                          width: 345,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            // keyboardType: TextInputType.multiline,
                            // minLines: 2, // <-- SEE HERE
                            // maxLines: 2,
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Product Description Required'
                                  : null;
                            },
                            controller: _itemDateController,

                            // onSaved: (value) {
                            //   productData['Description'] = value!;
                            // },
                            // controller: _emailTextController,
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              border: OutlineInputBorder(),

                              // prefixIcon: IconButton(
                              //     onPressed: () {},
                              //     icon: Image.asset(AppIcons.emailIcon)),
                              contentPadding:
                                  const EdgeInsets.only(top: 5.0, left: 12.0),
                              hintText: 'Date',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: size.height / 100,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 270),
                        child: Text(
                          'Location',
                          textAlign: TextAlign.start,
                          style: ralewayStyle.copyWith(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 50.0,
                          width: 345,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            // keyboardType: TextInputType.multiline,
                            // minLines: 2, // <-- SEE HERE
                            // maxLines: 2,
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Product Description Required'
                                  : null;
                            },
                            controller: _itemLocationController,

                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              border: OutlineInputBorder(),

                              // prefixIcon: IconButton(
                              //     onPressed: () {},
                              //     icon: Image.asset(AppIcons.emailIcon)),
                              contentPadding:
                                  const EdgeInsets.only(top: 5.0, left: 12.0),
                              hintText: 'Location',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 80,
                      ),
                      SizedBox(
                        width: size.width / 1.2,
                        child: const Text(
                          "Payment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      //=======================================================//
                      // PaymentOptionPage(),

                      Center(
                        child: SizedBox(
                          width: 345,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Color(0xFF292639),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: TabBar(
                                      controller: _tabController,
                                      indicator: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 19, 38, 94),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      tabs: [
                                        Tab(
                                          text: 'Direct Deposit ',
                                        ),
                                        Tab(
                                          text: "E-transfer ",
                                        )
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? 'Product Description Required'
                                                    : null;
                                              },

                                              // controller: _itemLocationController,
                                              controller:
                                                  _itemAccountNoController,

                                              style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blueDarkColor,
                                                fontSize: 16.0,
                                              ),
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                border: OutlineInputBorder(),

                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 5.0, left: 12.0),
                                                hintText: 'Account Number',
                                                hintStyle:
                                                    ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.blueDarkColor
                                                      .withOpacity(0.5),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? 'Product Description Required'
                                                    : null;
                                              },
                                              controller:
                                                  _itemInstitutionNoController,
                                              style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blueDarkColor,
                                                fontSize: 16.0,
                                              ),
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                border: OutlineInputBorder(),

                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 5.0, left: 12.0),
                                                hintText: 'Institution No',
                                                hintStyle:
                                                    ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.blueDarkColor
                                                      .withOpacity(0.5),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? 'Product Description Required'
                                                    : null;
                                              },
                                              controller:
                                                  _itemTransitNoController,
                                              style: ralewayStyle.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blueDarkColor,
                                                fontSize: 16.0,
                                              ),
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                border: OutlineInputBorder(),

                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 5.0, left: 12.0),
                                                hintText: 'Transit No',
                                                hintStyle:
                                                    ralewayStyle.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.blueDarkColor
                                                      .withOpacity(0.5),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                'Email Address : etransfer@backers.ca'),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //======================================================//

                      //=====================================================//
                      Center(
                        child: SizedBox(
                            width: 345,
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF292639),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: const TabBar(
                                        tabs: [
                                          Tab(
                                            text: 'Partial Payment ',
                                          ),
                                          Tab(
                                            text: 'EFT ',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: TabBarView(
                                      children: [
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  'Email Address : etransfer@backers.ca'),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  'Email Address : etransfer@backers.ca'),
                                            ],
                                          ),
                                        ),
                                        // Icon(Icons.directions_bike),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),

                      //======================================================//

                      //=======================================================//

                      SizedBox(
                        height: size.height / 80,
                      ),
                      Container(
                          height: 50.0,
                          width: 345,
                          child: TextButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('AlertDialog Title'),
                                content: const Text(
                                    'To confirm click confirm button'),
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
                                        UpdateAgreement();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueDarkColor),
                          )),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //   height: 50.0,
                      //   width: 345,
                      //   child: ElevatedButton(
                      //     child: const Text('Confirm'),
                      //     style: ElevatedButton.styleFrom(
                      //         backgroundColor: AppColors.blueDarkColor),
                      //     onPressed: () {
                      //       UpdateAgreement();
                      //     },
                      //   ),
                      // ),

                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
              //       // Expanded(
              //       //   child: customButtom(size, () {}, Colors.white, "Buy Now"),
              //       // ),
              //     ],
              //   ),
              // ),

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
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
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
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
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
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ));
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

  void UpdateAgreement() async {
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
    uploadFile1(img);
    setState(() {
      isLoading = false;
    });
    print('inside the update Agreement Function');
    // final User? user = auth.currentUser;
    // final uid = user?.uid;
    // var res = FirebaseFirestore.instance.collection('Agreement').add({
    //   'name': widget.product.name,
    //   'price': widget.product.price,
    //   'description': widget.product.description,
    //   'date': widget.product.date,
    //   'location': widget.product.location,
    //   'signature': widget.product.signature,
    //   'img': widget.product.img,
    //   'user_Id': uid,
    //   'client_name': _itemNameController.text,
    //   'client_date': _itemDateController.text,
    //   'client_location': _itemLocationController.text,
    //   'client_signature': _itemSignatureController.text,
    //   'account_No': _itemAccountNoController.text,
    //   'institution_No': _itemInstitutionNoController.text,
    //   'transit_No': _itemTransitNoController.text
    // });
  }
}
