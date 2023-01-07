import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/screens/app_colors.dart';
import 'package:marketplace/screens/app_icons.dart';
import 'package:marketplace/screens/app_styles.dart';
import 'package:marketplace/screens/complete_agreement_page.dart';
// import 'package:marketplace/model/user.dart';
import 'package:marketplace/screens/data_controller.dart';

import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/image.dart';
import 'package:marketplace/screens/login_user_product_screen.dart';

import 'package:marketplace/screens/image.dart';

import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/review_page.dart';
import 'package:marketplace/screens/save_data.dart';
import 'package:signature/signature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'auth.dart';
import 'dart:io' as io;

// import '../model/book.dart';
final ImagePicker _picker = ImagePicker();
PickedFile? _imagePickerFile;
var uuid = Uuid();

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  User? user;
  bool currentUser = false;
  String? link;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('eAgree Marketplace'),
          backgroundColor: AppColors.blueDarkColor,
        ),
        backgroundColor: AppColors.backColor,
        body: Container(
          alignment: Alignment.center,
          child: const SizedBox(
            width: 350,
            child: MyCustomForm(),
          ),
        ));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> productData = {
    "p_name": "",
    "p_price": "",
  };

  addProduct() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      DataController().addNewProduct(productData);
    }
  }

  User? user;
  bool currentUser = false;
  String? link;
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imagePickerFile;
  var uuid = Uuid();

  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    PickedFile? _imagePickerFile;
    var uuid = Uuid();
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),

        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Text('Create Your Agreement',
                      style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blueDarkColor,
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 20),
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
                      onSaved: (value) {
                        productData['p_name'] = value!;
                      },
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
                        hintText: 'Iphone 13',
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
                  height: 10,
                ),
                // //========================================//

                //===========================================//
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Product Price',
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
                        return value!.isEmpty ? 'Product Price Required' : null;
                      },
                      onSaved: (value) {
                        productData['p_price'] = value!;
                      },
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
                        hintText: 'Product Price',
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
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
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
                      onSaved: (value) {
                        productData['Description'] = value!;
                      },
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
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Signature',
                          textAlign: TextAlign.start,
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        child: Signature(
                          controller: _controller,
                          backgroundColor: Color.fromARGB(255, 239, 236, 236),
                          width: 510,
                          height: 200,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueDarkColor),
                      onPressed: () {
                        _controller.clear();
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // child: ElevatedButton(
                    //   child: const Text("Clear"),
                    //   onPressed: () {
                    //     _controller.clear();
                    //   },
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 20),
                  child: Text(
                    'Date',
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
                        return value!.isEmpty ? 'Date' : null;
                      },
                      onSaved: (value) {
                        productData['p_name'] = value!;
                      },
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
                        hintText: 'Date',
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
                  padding: const EdgeInsets.only(left: 12.0, top: 20),
                  child: Text(
                    'Location',
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
                      onSaved: (value) {
                        productData['p_name'] = value!;
                      },
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
                        hintText: 'Location',
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
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Text('Authorization / Fees',
                      style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blueDarkColor,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20.0),
                //   child: Text(
                //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                //       style: ralewayStyle.copyWith(
                //         fontWeight: FontWeight.w800,
                //         color: AppColors.blueDarkColor,
                //       )),
                // ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),

                //========================================================//

                const SizedBox(
                  height: 30,
                ),

                const SizedBox(
                  height: 30,
                ),

                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChoosenImage()),
                      );
                    },
                    child: const Text('upload file')),
                ElevatedButton(
                  onPressed: addProduct,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                ),

                //===================================//
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Go to agreement page'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompleteAgreement()),
                    );
                  },
                ),
                //====================================//
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Go to review page'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReviewPage()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('image picker'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductImagePicker()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('firestore'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => saveData()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Your Product'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => LoginUserProductScreen()),
                    // );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('All Product'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}

Widget get choosenImageWidget {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: choosenImageWithPicker, child: Text('Choose Image'))
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imagePickerFile == null
              ? Text('Henüz bir seçim yapılmadı..')
              : SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(_imagePickerFile!.path),
                )
        ],
      ),
    ],
  );
}

Future<void> choosenImageWithPicker() async {
  try {
    final file = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imagePickerFile = file;
    });
  } catch (err) {
    print(err);
  }
}

void setState(Null Function() param0) {}

Future<Future<String>?> uploadData(PickedFile file) async {
  try {
    if (file == null) {
      const SnackBar(content: Text('No file was selected'));
      return null;
    }
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child('${uuid.v4()}.jpg');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    if (kIsWeb) {
      ref.putData(await file.readAsBytes(), metadata);
    } else {
      ref.putFile(io.File(file.path), metadata);
    }
    return ref.getDownloadURL();
  } catch (err) {
    print(err);
    return null;
  }
}
