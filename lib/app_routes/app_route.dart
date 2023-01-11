import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace/error_screen.dart';
import 'package:marketplace/model/Agreement.dart';
import 'package:marketplace/model/product_model.dart';
import 'package:marketplace/screens/TnC.dart';
import 'package:marketplace/screens/final_screen.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/login_page.dart';
import 'package:marketplace/screens/login_user_product_screen.dart';
import 'package:marketplace/screens/myProfile.dart';
import 'package:marketplace/screens/pdetails.dart';
import 'package:marketplace/screens/privacy.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/screens/product_overview.dart';
import 'package:marketplace/screens/show_agreement.dart';
import 'package:marketplace/screens/sign_off.dart';
import 'package:marketplace/screens/user_agreement.dart';

class RouteCon {
  static const home = 'home';
  static const login = 'login';
  static const profile = 'profile';
  static const addproduct = 'addproduct';
  static const productdetail = 'productdetail';
  static const productoverview = 'productoverview';
  static const finalscreen = 'finalscreen';
  static const showagreement = 'showagreement';
  static const yourProducts = " yourProducts";
  static const terms = 'terms';
  static const privacy = 'privacy';
  static const useragr = "useragr";
  static const signoff = "signoff";
}

class AppRoutes {
  GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteCon.home,
        path: "/",
        builder: (context, state) {
          return HomeScreen();
        },
        redirect: (context, state) async {
          User? firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            return '/';
          } else {
            return '/login';
          }
        },
      ),
      GoRoute(
        name: RouteCon.login,
        path: "/login",
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: RouteCon.profile,
        path: "/profile",
        builder: (context, state) => Profile(),
      ),
      GoRoute(
        name: RouteCon.addproduct,
        path: "/addproducts",
        builder: (context, state) => ProductImagePicker(),
      ),
      GoRoute(
        name: RouteCon.productdetail,
        path: "/productdetail/view/:productId",
        builder: (context, state) {
          // Product sample = state.extra as Product;
          return Detail(
            pId: state.params['productId']!,
          );
        },
      ),
      GoRoute(
        name: RouteCon.yourProducts,
        path: "/yourProducts",
        builder: (context, state) {
          // Product sample = state.extra as Product;
          return LoginUserProductScreen();
        },
      ),
      GoRoute(
        name: RouteCon.productoverview,
        path: "/productoverview/view",
        builder: (context, state) {
          Product product = state.extra as Product;
          return ProductOverview(product);
        },
      ),
      GoRoute(
        name: RouteCon.showagreement,
        path: "/showagreement",
        builder: (context, state) {
          Agreement agreement = state.extra as Agreement;
          return ShowAgreement(agreement);
        },
      ),
      GoRoute(
        name: RouteCon.signoff,
        path: "/signoff",
        builder: (context, state) {
          Agreement agreement = state.extra as Agreement;
          return SignOff(agreement);
        },
      ),
      GoRoute(
        name: RouteCon.finalscreen,
        path: "/finalscreen",
        builder: (context, state) => FinalScreen(),
      ),
      GoRoute(
        name: RouteCon.terms,
        path: "/terms",
        builder: (context, state) => Terms(),
      ),
      GoRoute(
        name: RouteCon.privacy,
        path: "/privacy",
        builder: (context, state) => Privacy(),
      ),
      GoRoute(
        name: RouteCon.useragr,
        path: "/useragr",
        builder: (context, state) => UserAgreement(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
