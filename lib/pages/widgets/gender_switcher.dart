import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class GenderSwitcher extends StatelessWidget {

  ValueNotifier<bool> gender;
  VoidCallback? onPressedMale;
  VoidCallback? onPressedFemale;

  GenderSwitcher(
      {required this.gender,
      this.onPressedMale,
      this.onPressedFemale,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton.icon(
            onPressed: onPressedMale,
            icon: Icon(
              Icons.male,
              color: gender.value
                  ? mainColor
                  : Theme.of(context).unselectedWidgetColor,
              size: 26,
            ),
            label: Text('Муж',
                style: TextStyle(
                  fontSize: 18,
                  color: gender.value
                      ? mainColor
                      : Theme.of(context).unselectedWidgetColor,
                )),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
              side: BorderSide(
                  color: gender.value
                      ? mainColor
                      : Theme.of(context).unselectedWidgetColor,
                  width: gender.value ? 2 : 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onPressedFemale,
            icon: Icon(
              Icons.female,
              color: gender.value
                  ? Theme.of(context).unselectedWidgetColor
                  : mainColor,
              size: 26,
            ),
            label: Text('Жен',
                style: TextStyle(
                  fontSize: 18,
                  color: gender.value
                      ? Theme.of(context).unselectedWidgetColor
                      : mainColor,
                )),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
              side: BorderSide(
                  color: gender.value
                      ? Theme.of(context).unselectedWidgetColor
                      : mainColor,
                  width: gender.value ? 1 : 2),
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
