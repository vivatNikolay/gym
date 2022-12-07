import 'package:flutter/material.dart';

import '../../../../helpers/constants.dart';

class GenderSwitcher extends StatelessWidget {

  ValueNotifier<bool> gender;
  VoidCallback? onPressedMale;
  VoidCallback? onPressedFemale;

  GenderSwitcher({
    required this.gender,
    this.onPressedMale,
    this.onPressedFemale,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton.icon(
            onPressed: onPressedMale,
            icon: const Icon(Icons.male),
            label: const Text(" Male ",
                style: TextStyle(fontSize: 18, color: mainColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 13, horizontal: 25),
              side: BorderSide(
                  color: gender.value
                      ? mainColor
                      : Theme.of(context).unselectedWidgetColor,
                  width: gender.value ? 3 : 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onPressedFemale,
            icon: const Icon(Icons.female),
            label: const Text("Female",
                style: TextStyle(fontSize: 18, color: mainColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 13, horizontal: 25),
              side: BorderSide(
                  color: gender.value
                      ? Theme.of(context).unselectedWidgetColor
                      : mainColor,
                  width: gender.value ? 1 : 3),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
