import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class FieldName extends StatelessWidget {
  final String text;

  const FieldName({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'PT-Sans',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: mainColor,
        ),
      ),
    );
  }
}
