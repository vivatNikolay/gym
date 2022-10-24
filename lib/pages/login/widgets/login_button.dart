import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class LoginButton extends StatelessWidget {
  VoidCallback? onPressed;

  LoginButton({
    this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black12,
          side: const BorderSide(
              color: mainColor, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          'Log in',
          style: TextStyle(
            color: mainColor,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
