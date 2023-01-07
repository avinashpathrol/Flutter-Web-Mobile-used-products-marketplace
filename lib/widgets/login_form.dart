import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marketplace/screens/forgot_password.dart';
import 'package:marketplace/screens/home_screen.dart';
import 'package:marketplace/screens/product_image_picker.dart';
import 'package:marketplace/widgets/create_account_form.dart';
import '../screens/main_screen.dart';
import 'package:marketplace/screens/app_colors.dart';
import 'package:marketplace/screens/app_icons.dart';
import 'package:marketplace/screens/app_styles.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
    GlobalKey<FormState>? fornKey,
    TextEditingController? emailTextController,
    TextEditingController? passwordTextController,
  })  : _fornKey = fornKey!,
        _emailTextController = emailTextController!,
        _passwordTextController = passwordTextController!,
        super(key: key);

  final GlobalKey<FormState> _fornKey;
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  var userID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // var userID;
    return Form(
      key: _fornKey,
      child: Column(children: [
        Text('',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 40,
            width: 320,
            child: // with custom text
                SignInButton(
              Buttons.Facebook,
              text: "Login with Facebook",
              onPressed: () async {
                try {
                  final _instance = FacebookAuth.instance;
                  final result = await _instance.login(permissions: ['email']);
                  if (result.status == LoginStatus.success) {
                    final OAuthCredential credential =
                        FacebookAuthProvider.credential(
                            result.accessToken!.token);
                    final a = await _auth.signInWithCredential(credential);
                    await _instance.getUserData().then((userData) async {
                      await _auth.currentUser!.updateEmail(userData['email']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    });
                    return null;
                  } else if (result.status == LoginStatus.cancelled) {
                    return 'Login cancelled';
                  } else {
                    return 'Error';
                  }
                } catch (e) {
                  return e.toString();
                }
              },
            )),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 270.0),
          child: Text(
            'Email',
            textAlign: TextAlign.start,
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 6.0),
        Container(
          height: 50.0,
          width: 325,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Enter Email' : null;
            },
            controller: _emailTextController,
            style: ralewayStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.blueDarkColor,
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: IconButton(
                  onPressed: () {}, icon: Image.asset(AppIcons.emailIcon)),
              contentPadding: const EdgeInsets.only(top: 16.0),
              hintText: 'Enter Email',
              hintStyle: ralewayStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.blueDarkColor.withOpacity(0.5),
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 245.0),
          child: Text(
            'Password',
            style: ralewayStyle.copyWith(
              fontSize: 12.0,
              color: AppColors.blueDarkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          height: 50.0,
          width: 325,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
          ),
          child: TextFormField(
            validator: ((value) {
              return value!.isEmpty ? 'Enter Password' : null;
            }),
            controller: _passwordTextController,
            style: ralewayStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.blueDarkColor,
              fontSize: 14.0,
            ),
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                  onPressed: () {}, icon: Image.asset(AppIcons.eyeIcon)),
              prefixIcon: IconButton(
                  onPressed: () {}, icon: Image.asset(AppIcons.lockIcon)),
              contentPadding: const EdgeInsets.only(top: 16.0),
              hintText: 'Enter Password',
              hintStyle: ralewayStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.blueDarkColor.withOpacity(0.5),
                fontSize: 12.0,
              ),
            ),
          ),
        ),

        // SizedBox(height: height * 0.03),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //       onPressed: () {},
        //       child: Text(
        //         'Forgot Password?',
        //         style: ralewayStyle.copyWith(
        //           fontSize: 12.0,
        //           color: AppColors.mainBlueColor,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       )),
        // ),
        const SizedBox(
          height: 30,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (_fornKey.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text);
                  userID = credential.user!.uid;
                  print(credential.user?.uid);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
                // var response = FirebaseAuth.instance
                //     .signInWithEmailAndPassword(
                //         email: _emailTextController.text,
                //         password: _passwordTextController.text)
                //     .then((value) {
                //   //print(value.user?.uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
              }
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Ink(
                padding: const EdgeInsets.symmetric(
                    horizontal: 70.0, vertical: 18.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.blueDarkColor,
                ),
                child: Text(
                  'Sign In',
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    fontSize: 16.0,
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blueDarkColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
              },
              child: Text('Forgot Password?')),
        ),

        const SizedBox(
          height: 5,
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: TextButton(
        //       style: TextButton.styleFrom(
        //         foregroundColor: AppColors.blueDarkColor,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => CreateAccountForm(
        //                       fornKey: _fornKey,
        //                       emailTextController: _emailTextController,
        //                       passwordTextController: _passwordTextController,
        //                     )));
        //       },
        //       child: Text('Dont have an account? Sign Up')),
        // ),
      ]),
    );
  }
}
