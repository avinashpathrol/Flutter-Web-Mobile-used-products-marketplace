import 'dart:convert';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:uuid/uuid.dart';

import '../components/bottom_bar.dart';
import '../components/topbar.dart';
import '../utils/styles/app_colors.dart';
import '../utils/styles/app_styles.dart';

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
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
    _getCurrentLocation();
    _itemPartialPayController.text = "\$" + percent().toString();
    _itemFullPayController.text = "\$" + widget.product.price.toString();
  }

  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are  denind");
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: "Location permissions are permanently denind");
      }
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: false)
        .then((Position position) {
      setState(() {
        _curentPosition = position;
        print("ok ${_curentPosition!.latitude}");
        // _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
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
    FirebaseFirestore.instance.collection('Agreement').add({
      'name': widget.product.name,
      'seller_name': widget.product.seller_name,
      'price': widget.product.price,
      'description': widget.product.description,
      'date': widget.product.date,
      'location': widget.product.location,
      'signature': widget.product.signature,
      'img': widget.product.img,
      'buyer_id': uid,
      'sellerId': widget.product.userId,
      'client_name': _itemNameController.text,
      'client_date': _itemDateController.text,
      'client_location': _itemLocationController.text,
      'client_signature': signUrl,
      'account_No': _itemAccountNoController.text,
      'institution_No': _itemInstitutionNoController.text,
      'transit_No': _itemTransitNoController.text,
      'partial_pay': _itemPartialPayController.text,
      'productId': widget.product.productId,
      'agreementStatus': false,
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Agreement Uploaded')));
      // sendPushMessage();
      print(value.id);
      FirebaseFirestore.instance
          .collection('Agreement')
          .doc(value.id)
          .update({'docId': value.id});
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please wait from buyer side to accep agreement')));

      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.product.userId)
          .get()
          .then((value) {
        // print("pppp ${value['deviceToken']}");
        sendPushMessageToWeb(
            value['deviceToken'], 'new agreement recieved', 'detail ');
        Navigator.pop(context);
        GoRouter.of(context).goNamed(RouteCon.showagreement);
      });
      // GoRouter.of(context).pushNamed(RouteCon.finalscreen);
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

  TextEditingController _itemFullPayController = TextEditingController();

  TextEditingController _signatureController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;
  bool _isSelected = false;
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

  double percent() {
    return double.parse(widget.product.price!) * 0.10;
  }

  String signUrl = '';
  String psignUrl = '';

  // int _value = 0;
  String paymentType = '';

  // SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  Widget build(BuildContext context) {
    // print("okok ${percent()}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getLoginUserProduct();
    });
    final Size size = Get.size;
    // final controller = Get.put(ItemDetailController());

    // controller.getItemDetails(id);

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.amberAccent, // <-- SEE HERE
                onPrimary: Colors.redAccent, // <-- SEE HERE
                onSurface: Colors.blueAccent, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      setState(() {
        if (selected != null) {
          String fdate = DateFormat('yyyy-MM-dd').format(selected);
          _itemDateController.text = fdate;
        }
      });
    }

    userLoc() {
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: Icon(Icons.close)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: OpenStreetMapSearchAndPick(
                        center: LatLong(_curentPosition!.latitude,
                            _curentPosition!.longitude),
                        buttonColor: Colors.blue,
                        buttonText: 'Set Current Location',
                        onPicked: (pickedData) {
                          setState(() {
                            _itemLocationController.text = pickedData.address;
                          });
                          GoRouter.of(context).pop();
                        }),
                  ),
                ],
              ));
    }

    return Container(
      color: Color(0xff252B5C),
      child: SafeArea(
        child: GetBuilder<DataController>(
          builder: (value) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: TopBar(),
              ),
              body: SizedBox(
                height: size.height,
                width: size.width,
                child: isLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Form(
                        key: _formKey,
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
                                          image:
                                              NetworkImage(widget.product.img!),
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
                                widget.product.name!,
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
                                widget.product.description!,
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
                                widget.product.location!,
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
                                widget.product.date!,
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
                              height: size.height / 80,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blueDarkColor),
                                onPressed: () {
                                  key.currentState!.clear();
                                },
                                child: Text('Clear')),
                            SizedBox(
                              height: size.height / 80,
                            ),
                            Container(
                                width: 325,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            isChecked = newValue!;
                                          });
                                        }),
                                    Text(
                                      'I have read the agreement and I accept it',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: size.height / 100,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 290),
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
                                    contentPadding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    hintText: 'Name',
                                    hintStyle: ralewayStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blueDarkColor
                                          .withOpacity(0.5),
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
                              padding:
                                  const EdgeInsets.only(top: 20, right: 300),
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
                                        ? 'Date Required'
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
                                    contentPadding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    hintText: 'Date',
                                    hintStyle: ralewayStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blueDarkColor
                                          .withOpacity(0.5),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: size.height / 100,
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 270),
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
                                        ? 'Location Required'
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
                                    contentPadding: const EdgeInsets.only(
                                        top: 5.0, left: 12.0),
                                    hintText: 'Location',
                                    hintStyle: ralewayStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blueDarkColor
                                          .withOpacity(0.5),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onTap: () {
                                    userLoc();
                                  },
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: TabBar(
                                            controller: _tabController,
                                            indicator: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 19, 38, 94),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            tabs: [
                                              Tab(
                                                text: 'Partial Payment ',
                                              ),
                                              Tab(
                                                text: "Full Payment ",
                                              )
                                            ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 150,
                                      child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextFormField(
                                                    readOnly: true,
                                                    validator: (value) {
                                                      return value!.isEmpty
                                                          ? 'Put 10% of the product cost as patial payment'
                                                          : null;
                                                    },
                                                    // controller: _itemLocationController,
                                                    controller:
                                                        _itemPartialPayController,

                                                    style:
                                                        ralewayStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .blueDarkColor,
                                                      fontSize: 16.0,
                                                    ),
                                                    decoration: InputDecoration(
                                                      // border: InputBorder.none,
                                                      border:
                                                          OutlineInputBorder(),

                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              left: 12.0),
                                                      hintText:
                                                          'Put 10% of the product cost as patial payment',
                                                      hintStyle:
                                                          ralewayStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blueDarkColor
                                                            .withOpacity(0.5),
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // child: Column(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceEvenly,
                                              //   children: [
                                              //     Text(
                                              //         'Email Address : etransfer@backers.ca'),
                                              //   ],
                                              // ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextFormField(
                                                    readOnly: true,
                                                    validator: (value) {
                                                      return value!.isEmpty
                                                          ? ' 10% as patial payment'
                                                          : null;
                                                    },
                                                    // controller: _itemLocationController,
                                                    controller:
                                                        _itemFullPayController,

                                                    style:
                                                        ralewayStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .blueDarkColor,
                                                      fontSize: 16.0,
                                                    ),
                                                    decoration: InputDecoration(
                                                      // border: InputBorder.none,
                                                      border:
                                                          OutlineInputBorder(),

                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              left: 12.0),
                                                      hintText: 'Pay in Full ',
                                                      hintStyle:
                                                          ralewayStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blueDarkColor
                                                            .withOpacity(0.5),
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
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
                                                  text: 'EFT ',
                                                ),
                                                Tab(
                                                  text: 'eTransfer ',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 300,
                                          child: TabBarView(
                                            children: [
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextFormField(
                                                      validator: (value) {
                                                        return value!.isEmpty
                                                            ? 'Account Number Required'
                                                            : null;
                                                      },

                                                      // controller: _itemLocationController,
                                                      controller:
                                                          _itemAccountNoController,

                                                      style:
                                                          ralewayStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 16.0,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        // border: InputBorder.none,
                                                        border:
                                                            OutlineInputBorder(),

                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5.0,
                                                                left: 12.0),
                                                        hintText:
                                                            'Account Number',
                                                        hintStyle: ralewayStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blueDarkColor
                                                              .withOpacity(0.5),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      validator: (value) {
                                                        return value!.isEmpty
                                                            ? 'Institution No Required'
                                                            : null;
                                                      },
                                                      controller:
                                                          _itemInstitutionNoController,
                                                      style:
                                                          ralewayStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 16.0,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        // border: InputBorder.none,
                                                        border:
                                                            OutlineInputBorder(),

                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5.0,
                                                                left: 12.0),
                                                        hintText:
                                                            'Institution No',
                                                        hintStyle: ralewayStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blueDarkColor
                                                              .withOpacity(0.5),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      validator: (value) {
                                                        return value!.isEmpty
                                                            ? 'Transit No Required'
                                                            : null;
                                                      },
                                                      controller:
                                                          _itemTransitNoController,
                                                      style:
                                                          ralewayStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 16.0,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        // border: InputBorder.none,
                                                        border:
                                                            OutlineInputBorder(),

                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5.0,
                                                                left: 12.0),
                                                        hintText: 'Transit No',
                                                        hintStyle: ralewayStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blueDarkColor
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                            Container(
                              height: 50.0,
                              width: 345,
                              child: TextButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        // title: const Text('AlertDialog Title'),
                                        content: const Text(
                                            'To confirm click confirm button'),

                                        actions: <Widget>[
                                          //
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
                                    );
                                  }
                                },
                                child: const Text('Confirm'),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.blueDarkColor),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            // Container(
                            //   height: 50.0,
                            //   width: 345,
                            //   child: ElevatedButton(
                            //     child: const Text('Export to PDF'),
                            //     style: ElevatedButton.styleFrom(
                            //         backgroundColor: AppColors.blueDarkColor),
                            //     onPressed: () {
                            //       // Navigator.push(
                            //       //   context,
                            //       //   MaterialPageRoute(builder: (context) => saveData()),
                            //       // );
                            //     },
                            //   ),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
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

              bottomNavigationBar: BottomBar(size: size),
            );
          },
        ),
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
    // setState(() {
    //   isLoading = true;
    // });

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
    // setState(() {
    //   isLoading = false;
    // });
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
