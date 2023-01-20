import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/widgets/login_form.dart';

class DataController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Product> loginUserData = [];
  List<Product> allProduct = [];
  List<Agreement> loginAgreementData = [];
  Future<void> addNewProduct(Map productdata) async {
    print("inside the data controller");
    try {
      // var response =

      await FirebaseFirestore.instance.collection('productData').add({
        'name': productdata['p_name'],
        'price': productdata['p_price'],
        'user_Id': LoginForm().userID
      });
      // print("Firebase response1111 $response");
      // CommanDialog.hideLoading();
      // Get.back();
    } catch (exception) {
      // CommanDialog.hideLoading();
      print("Error Saving Data at firestore $exception");
    }
  }

  @override
  void onReady() {
    super.onReady();
    getAllProduct();
    getLoginUserProduct();
  }

  Future<void> getLoginUserProduct() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print("loginUserData YEs $loginUserData");
    loginUserData = [];
    try {
      final List<Product> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('productData')
          .where('user_Id', isEqualTo: uid)
          .get();

      if (response.docs.length > 0) {
        response.docs.forEach(
          (result) {
            print(result.data());
            print("Product ID  ${result.id}");
            lodadedProduct.add(
              Product(
                productId: result.id,
                signature: result['signature'],
                seller_name: result['seller_name'],
                userId: result['user_Id'],
                name: result['name'],
                price: result['price'],
                img: result['img'],
                description: result['description'],
                location: result['location'],
                date: result['date'],
              ),
            );
          },
        );
      }
      loginUserData.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

  Future<void> getAllProduct() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print("loginUserData YEs $loginUserData");
    loginUserData = [];
    try {
      final List<Product> lodadedProduct = [];
      var response = await FirebaseFirestore.instance
          .collection('productData')
          .where('user_Id', isNotEqualTo: uid)
          .get();

      if (response.docs.length > 0) {
        response.docs.forEach(
          (result) {
            print(result.data());
            print("Product ID  ${result.id}");
            lodadedProduct.add(
              Product(
                productId: result['productId'],
                signature: result['signature'],
                seller_name: result['seller_name'],
                userId: result['user_Id'],
                name: result['name'],
                price: result['price'],
                img: result['img'],
                description: result['description'],
                location: result['location'],
                date: result['date'],
              ),
            );
          },
        );
      }
      loginUserData.addAll(lodadedProduct);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

  Future<void> getAgreementData() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print("AgreementData YEs $loginAgreementData");
    loginAgreementData = [];
    try {
      final List<Agreement> lodadedAgreement = [];
      var response = await FirebaseFirestore.instance
          .collection('Agreement')
          .where('user_Id', isEqualTo: uid)
          .get();

      if (response.docs.length > 0) {
        print('-------- if condition ----------');
        response.docs.forEach(
          (result) {
            print(result.data());
            print("Agreement ID  ${result.id}");
            lodadedAgreement.add(
              Agreement(
                agreementId: result.id,
                signature: result['signature'],
                seller_name: result['seller_name'],
                user_Id: result['user_Id'],
                name: result['name'],
                price: result['price'],
                img: result['img'],
                docId: result.id,
                description: result['description'],
                location: result['location'],
                date: result['date'],
                account_no: result['account_No'],
                client_date: result['client_date'],
                client_location: result['client_location'],
                client_signature: result['client_signature'],
                client_name: result['client_name'],
                institution_no: result['institution_No'],
                transit_no: result['transit_No'],
                partial_pay: result['partial_pay'],
                productId: result['productId'],
              ),
            );
          },
        );
      }
      loginAgreementData.addAll(lodadedAgreement);
      update();
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
  }

  Future editProduct(productId, price) async {
    print("Product Id  $productId");
    try {
      // CommanDialog.showLoading();
      await FirebaseFirestore.instance
          .collection("productData")
          .doc(productId)
          .update({"price": price}).then((_) {
        // CommanDialog.hideLoading();
        getLoginUserProduct();
      });
    } catch (error) {
      // CommanDialog.hideLoading();
      // CommanDialog.showErrorDialog();

      print(error);
    }
  }

  Future deleteProduct(String productId) async {
    print("Product Iddd  $productId");
    try {
      // CommanDialog.showLoading();
      await FirebaseFirestore.instance
          .collection("productData")
          .doc(productId)
          .delete()
          .then((_) {
        // CommanDialog.hideLoading();
        getLoginUserProduct();
      });
    } catch (error) {
      // CommanDialog.hideLoading();
      // CommanDialog.showErrorDialog();
      print(error);
    }
  }
}
