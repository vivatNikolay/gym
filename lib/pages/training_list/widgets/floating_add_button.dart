import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class FloatingAddButton extends StatelessWidget {
  final String text;
  VoidCallback? onPressed;

  FloatingAddButton({required this.text, this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            mainColor.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
