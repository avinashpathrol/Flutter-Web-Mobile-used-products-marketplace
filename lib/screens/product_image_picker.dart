import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/app_routes/app_route.dart';
import 'package:marketplace/components/topbar.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/new/myProfile.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:uuid/uuid.dart';

import '../utils/styles/app_colors.dart';
import '../utils/styles/app_styles.dart';

class ProductImagePicker extends StatefulWidget {
  @override
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  bool isChecked = false;
  bool _isSelected = false;
  final Size size = Get.size;
  int myIndex = 0;
  List<Widget> widgetList = [HomeScreen(), Profile()];
  String defaultImageUrl =
      // 'https://cdn.pixabay.com/photo/2016/03/23/15/00/ice-cream-1274894_1280.jpg';
      "https://i.ibb.co/9mxH56C/360-F-217887350-m-Df-Lv2oot-QNeff-WXT57-VQr8-OX7-Iv-ZKv-B.jpg";
  String selctFile = '';
  late XFile file;
  late Uint8List selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemSellerNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _deviceTokenController = TextEditingController();
  TextEditingController _itemDateController = TextEditingController();
  TextEditingController _itemLocationController = TextEditingController();
  TextEditingController _itemSignatureController = TextEditingController();
  TextEditingController _itemAccountNoController = TextEditingController();
  TextEditingController _itemInstitutionNoController = TextEditingController();
  TextEditingController _itemTransitNoController = TextEditingController();

  // bool isItemSaved = false;

  bool isLoading = false;
  // GlobalKey<SfSignaturePadState> key = GlobalKey();
  double min = 4.0;
  // Uuid? v;
  var uuid = Uuid();
  Uint8List? img;
  List<Color> colors = [Colors.black];
  Color? c;
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  // String signUrl = '';
  // String signature = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    //deleteVegetable();
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  _selectFile(bool imageForm) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes!;
      });
    }
  }

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
                backgroundColor: Colors.red, // button text color
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

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
        _itemLocationController.text = _curentAddress!;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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

  Future<UploadTask?> uploadFile1() async {
    // idGenerator();
    // if (file == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('No file was selected'),
    //     ),
    //   );

    //   return null;
    // }

    // UploadTask uploadTask;

    // // Create a Reference to the file
    // Reference ref = FirebaseStorage.instance
    //     .ref()
    //     .child('signature')
    //     .child('/${idGenerator()}.jpg');

    // final metadata = SettableMetadata(
    //   contentType: 'image/jpg',
    //   // customMetadata: {'picked-file-path': file},
    // );

    // uploadTask = ref.putData(file, metadata);
    // await uploadTask.whenComplete(() => null);
    // // signature = await ref.getDownloadURL();

    // setState(() {
    //   isLoading = true;
    //   // isItemSaved = true;
    // });
    String imageUrl = await _uploadFile();

    final User? user = auth.currentUser;
    final uid = user?.uid;
    // var id = await FirebaseFirestore.instance.collection('productData').doc();
    await FirebaseFirestore.instance.collection('productData').add({
      'name': _itemNameController.text,
      'seller_name': _itemSellerNameController.text,
      'price': _itemPriceController.text,
      'description': _itemDescriptionController.text,
      'date': _itemDateController.text,
      'location': _itemLocationController.text,
      // 'signature': signature,
      'img': imageUrl,
      'user_Id': uid,
      'productId': uuid.v4(),
      // 'signUrl': signUrl,
      'account_no': _itemAccountNoController.text,
      'institution_no': _itemInstitutionNoController.text,
      'transit_no': _itemTransitNoController.text
    }).then((value) {
      // CircularProgressIndicator();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Uploaded')));
      GoRouter.of(context).goNamed(RouteCon.home);
      // sendPushMessage();
      // setState(() {
      //   isItemSaved = false;
      // });

      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: ((context) => LoginUserProductScreen())));
    });
    // setState(() {
    //   isLoading = false;
    // });
    return Future.value();
  }

  Future<String> _uploadFile() async {
    String imageUrl = '';
    // setState(() {
    //   isLoading = true;
    // });
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('test')
          .child('/' + selctFile);

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      // uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(selectedImageInBytes, metadata);

      // uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(selectedImageInBytes, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
      setState(() {
        isLoading = false;
        // isItemSaved = false;
      });
    } catch (e) {
      print(e);
    }
    // setState(() {
    //   isLoading = false;
    // });
    return imageUrl;
  }

  saveItem() async {
    setState(() {
      isLoading = true;
      // isItemSaved = true;
    });
    // String imageUrl = await _uploadFile();

    // await _uploadMultipleFiles(_itemNameController.text);
    // print('Uploaded Image URL ' + imageUrls.length.toString());

    ///////////
    // ui.Image image = await key.currentState!.toImage();
    // final bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
    // final Uint8List imageBytes = bytedata!.buffer
    //     .asUint8List(bytedata.offsetInBytes, bytedata.lengthInBytes);
    // String e = base64.encode(imageBytes);
    // Uint8List decode = base64.decode(e);
    // setState(() {
    //   img = decode;
    // });
    await uploadFile1();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      backgroundColor: AppColors.backColor,
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                          height: 300,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: selctFile.isEmpty
                              ? Image.network(
                                  defaultImageUrl,
                                  fit: BoxFit.cover,
                                )

                              //==========================================//
                              : Image.memory(selectedImageInBytes)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //_showPicker(context);
                          _selectFile(true);
                        },
                        icon: const Icon(
                          Icons.camera,
                        ),
                        label: const Text(
                          'Pick Image',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    // if (isItemSaved)
                    //   Container(
                    //     child: CircularProgressIndicator(
                    //       color: Colors.green,
                    //     ),
                    //   ),

                    Padding(
                      padding: const EdgeInsets.only(right: 220, top: 20),
                      child: Text(
                        'Product Name',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Product Name' : null;
                          },
                          controller: _itemNameController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Ex: CAR ',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //==============================================//
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Item Price',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Item Price' : null;
                          },
                          controller: _itemPriceController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: '\$200',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //==============================================//
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Description',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 90.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 4, // <-- SEE HERE
                          maxLines: 10,
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Product Description Required'
                                : null;
                          },
                          controller: _itemDescriptionController,
                          // onSaved: (value) {
                          //   productData['Description'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Description',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text('Terms',
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.blueDarkColor,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "By Listing you acknowledge the loperisum loperisum loperisum loperisum",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    //==============================================//

                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Enter Name',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Name' : null;
                          },
                          controller: _itemSellerNameController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter Name',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Enter Date',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Date' : null;
                          },
                          onTap: () {
                            _selectDate(context);
                          },
                          readOnly: true,

                          controller: _itemDateController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter date',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Your Location',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Location' : null;
                          },
                          onTap: () {
                            userLoc();
                          },
                          controller: _itemLocationController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter Location',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 240, top: 20),
                    //   child: Text(
                    //     'Signature',
                    //     textAlign: TextAlign.start,
                    //     style: ralewayStyle.copyWith(
                    //       fontSize: 12.0,
                    //       color: AppColors.blueDarkColor,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20),
                    //   child: Container(
                    //     width: 350,
                    //     child: SfSignaturePad(
                    //       key: key,
                    //       backgroundColor: Colors.grey.shade400,
                    //       strokeColor: c,
                    //       minimumStrokeWidth: 10,
                    //       maximumStrokeWidth: min,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: size.height / 80,
                    ),
                    // ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.blueDarkColor),
                    //     onPressed: () {
                    //       key.currentState!.clear();
                    //     },
                    //     child: Text('Clear')),
                    // SizedBox(
                    //   height: size.height / 80,
                    // ),
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
                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text('Payment Details',
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.blueDarkColor,
                          )),
                    ),
                    SizedBox(
                      height: size.height / 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child:
                          Text('Enter bank details where you want to get paid',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                              )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Account No',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Account_no' : null;
                          },
                          controller: _itemAccountNoController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter Account No',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Institution No',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Institution' : null;
                          },
                          controller: _itemInstitutionNoController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter Transit No',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Transit No',
                        textAlign: TextAlign.start,
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? 'Institution' : null;
                          },
                          controller: _itemTransitNoController,
                          // onSaved: (value) {
                          //   productData['p_name'] = value!;
                          // },
                          // controller: _emailTextController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            // prefixIcon: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(AppIcons.emailIcon)),
                            contentPadding:
                                const EdgeInsets.only(top: 5.0, left: 12.0),
                            hintText: 'Enter Transit  No',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text('Authorization / Fees',
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.blueDarkColor,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Container(),

                    //====================================//
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 325,
                      // child: ElevatedButton(
                      //   child: const Text('Go to review page'),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors.blueDarkColor),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const ReviewPage()),
                      //     );
                      //   },
                      // ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50.0,
                        width: 345,
                        child: TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title:
                                  const Text('Confirmation for Adding Product'),
                              content: const Text(
                                  'confirm to push the product to marketplace ?'),
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
                                      saveItem();
                                      GoRouter.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: const Text('Submit'),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.blueDarkColor),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   width: 325,
                    //   child: ElevatedButton(
                    //     child: const Text('Your Product'),
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.blueDarkColor),
                    //     onPressed: () {
                    //       // Navigator.push(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //       builder: (context) => LoginUserProductScreen()),
                    //       // );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Container(
                    //   width: 325,
                    //   child: ElevatedButton(
                    //     child: const Text('All Product'),
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.blueDarkColor),
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => HomeScreen()),
                    //       );
                    //     },
                    //   ),
                    // ),

                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   width: 325,
                    //   child: ElevatedButton(
                    //     child: const Text('Continue'),
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.blueDarkColor),
                    //     onPressed: () {
                    //       saveItem();
                    //     },
                    //   ),
                    // ),

                    //==============================================//
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
