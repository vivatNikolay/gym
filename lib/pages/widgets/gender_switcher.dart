import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../helpers/constants.dart';

class GenderSwitcher extends StatelessWidget {

  final ValueNotifier<bool> gender;
  final VoidCallback? onPressedMale;
  final VoidCallback? onPressedFemale;

  const GenderSwitcher(
      {required this.gender,
      this.onPressedMale,
      this.onPressedFemale,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 8,
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
            label: Text('male'.i18n(),
                style: TextStyle(
                  fontSize: 18,
                  color: gender.value
                      ? mainColor
                      : Theme.of(context).unselectedWidgetColor,
                )),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
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
            label: Text('female'.i18n(),
                style: TextStyle(
                  fontSize: 18,
                  color: gender.value
                      ? Theme.of(context).unselectedWidgetColor
                      : mainColor,
                )),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
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
