import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'circle_image.dart';

class ImageSelector extends StatelessWidget {
  final ValueNotifier<int> iconNum;

  const ImageSelector({required this.iconNum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('selectAvatar'.i18n()),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(size.width * 0.05),
          child: Wrap(
            spacing: 30,
            runSpacing: 15,
            children: List.generate(
              6,
              (index) => CircleImage(
                  image: AssetImage('images/profileImg${index+1}.png'),
                  icon: iconNum.value == index+1 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = index+1;
                    Navigator.of(context).pop();
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
