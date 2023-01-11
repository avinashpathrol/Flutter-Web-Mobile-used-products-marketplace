import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:marketplace/screens/already_have_an_account.dart';

import 'package:marketplace/widgets/create_account_form.dart';
import 'package:marketplace/widgets/login_form.dart';
import 'package:marketplace/widgets/responsive_login_page.dart';
import '../utils/styles/app_styles.dart';
import '../utils/styles/app_colors.dart';

// import '../widgets/create_account_form.dart';
// import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCreatedAccountClicked = false;
  final _fornKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //---------------------------------------------//
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.backColor,
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      height: height,
                      margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveLoginPage.isSmallScreen(context)
                              ? height * 0.032
                              : height * 0.12),
                      color: AppColors.backColor,
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: height * 0.2),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: 'Welcome to eAgree',
                                  style: ralewayStyle.copyWith(
                                    fontSize: 25.0,
                                    color: AppColors.blueDarkColor,
                                    fontFamily: 'FontWeight.normal',
                                  ),
                                ),
                              ])),
                              SizedBox(height: height * 0.02),
                              Image.asset(
                                'assets/images/ea.png',
                                fit: BoxFit.contain,
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                child: isCreatedAccountClicked != true
                                    ? LoginForm(
                                        fornKey: _fornKey,
                                        emailTextController:
                                            _emailTextController,
                                        passwordTextController:
                                            _passwordTextController)
                                    : CreateAccountForm(
                                        fornKey: _fornKey,
                                        emailTextController:
                                            _emailTextController,
                                        passwordTextController:
                                            _passwordTextController),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AlreadyHaveAnAccountCheck(
                                press: () {
                                  setState(() {
                                    if (!isCreatedAccountClicked) {
                                      isCreatedAccountClicked = true;
                                      login:
                                      true;
                                    } else
                                      isCreatedAccountClicked = false;
                                    login:
                                    false;
                                  });
                                },
                                isCreatedAccountClicked:
                                    !isCreatedAccountClicked,
                              ),
                            ],
                          ))))
            ],
          ),
        ));
    //==============================//
  }
}
