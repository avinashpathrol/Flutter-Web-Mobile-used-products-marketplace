import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:marketplace/screens/app_colors.dart';
import 'package:marketplace/screens/app_icons.dart';
import 'package:marketplace/screens/app_styles.dart';
// import 'package:marketplace/model/user.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/signature_page.dart';
// IMPORT PACKAGE
import 'package:signature/signature.dart';

// import '../model/book.dart';

class CompleteAgreement extends StatelessWidget {
  CompleteAgreement({super.key});

  final _controller = SignatureController();

  @override
  Widget build(BuildContext context) {
    final _controller = SignatureController();

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
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

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> productData = {
    "p_name": "",
    "p_price": "",
    // "p_upload_date": DateTime.now().millisecondsSinceEpoch,
    // "phone_number": ""
  };

  addProduct() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      DataController().addNewProduct(productData);
    }
  }

  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        // child: Card(
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
                  child: Text('Complete Agreement',
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
                //=============================================//

                // const SizedBox(
                //   height: 30,
                // ),
                // const TextField(
                //   decoration: InputDecoration(labelText: 'Description'),
                //   keyboardType: TextInputType.multiline,
                //   minLines: 4, // <-- SEE HERE
                //   maxLines: 10, // <-- SEE HERE
                // ),

                //================================================//

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

                //========================================================//

                const SizedBox(
                  height: 30,
                ),
                // const ProductImagePicker(),
                //================================================//
                Padding(
                  padding: const EdgeInsets.only(left: 120.0, top: 20),
                  child: Text('Authorization',
                      style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blueDarkColor,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text(
                    'Terms',
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
                        hintText: 'Terms',
                        hintStyle: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blueDarkColor.withOpacity(0.5),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),

                //=================================================//
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
                ///////////////////
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 20),
                  child: Text(
                    'Payment',
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
                        return value!.isEmpty ? 'Account Number' : null;
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
                        hintText: 'Institution Number',
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
                        return value!.isEmpty ? 'Institution Number' : null;
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
                        hintText: 'Transit Number',
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
                        return value!.isEmpty ? 'Transit Number' : null;
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
                        hintText: 'Transit Number',
                        hintStyle: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blueDarkColor.withOpacity(0.5),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),

                //==================================================//

                // SignaturePage(),

                //================================================//
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: addProduct,
                  child: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarkColor),
                ),

                //=======================================================//
              ],
            ),
          ),
        ),
      ),
    );
  }
}
