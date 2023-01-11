import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../utils/styles/app_styles.dart';
import '../utils/styles/app_colors.dart';
// import 'package:marketplace/model/user.dart';
import 'package:marketplace/screens/data_controller.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/signature_page.dart';

// import '../model/book.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.only(left: 130.0),
                  child: Text('Review',
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
        // ),
      ),
    );
  }
}
