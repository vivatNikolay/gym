import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'circle_image.dart';

class ImageSelector extends StatelessWidget {
  final ValueNotifier<int> iconNum;

  const ImageSelector({required this.iconNum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('selectAvatar'.i18n()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleImage(
                  image: const AssetImage('images/profileImg1.png'),
                  icon: iconNum.value == 1 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 1;
                    Navigator.of(context).pop();
                  }),
              CircleImage(
                  image: const AssetImage('images/profileImg2.png'),
                  icon: iconNum.value == 2 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 2;
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleImage(
                  image: const AssetImage('images/profileImg3.png'),
                  icon: iconNum.value == 3 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 3;
                    Navigator.of(context).pop();
                  }),
              CircleImage(
                  image: const AssetImage('images/profileImg4.png'),
                  icon: iconNum.value == 4 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 4;
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleImage(
                  image: const AssetImage('images/profileImg5.png'),
                  icon: iconNum.value == 5 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 5;
                    Navigator.of(context).pop();
                  }),
              CircleImage(
                  image: const AssetImage('images/profileImg6.png'),
                  icon: iconNum.value == 6 ? Icons.check : null,
                  onTap: () {
                    iconNum.value = 6;
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
