import 'package:flutter/material.dart';

class EcoButton extends StatelessWidget {
  String? title;
  bool? isLoginButton;
  VoidCallback? onPress;
  bool? isLoading;

  EcoButton(
      {Key? key,
      this.title,
      this.isLoading = false,
      this.isLoginButton = false,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: isLoginButton == false ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading! ? false : true,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    title ?? "button",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading!,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
