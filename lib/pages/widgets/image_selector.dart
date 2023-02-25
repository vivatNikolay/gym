import 'package:flutter/material.dart';

import 'circle_image.dart';

class ImageSelector extends StatelessWidget {
  final ValueNotifier<int> iconNum;

  const ImageSelector({required this.iconNum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбрать аватар'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleImage(
                      image: const AssetImage('images/profileImg1.png'),
                      icon: iconNum.value == 1 ? Icons.check : null,
                      onTap: () {
                        iconNum.value = 1;
                        Navigator.pop(context);
                      }),
                  CircleImage(
                      image: const AssetImage('images/profileImg2.png'),
                      icon: iconNum.value == 2 ? Icons.check : null,
                      onTap: () {
                        iconNum.value = 2;
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      }),
                  CircleImage(
                      image: const AssetImage('images/profileImg4.png'),
                      icon: iconNum.value == 4 ? Icons.check : null,
                      onTap: () {
                        iconNum.value = 4;
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      }),
                  CircleImage(
                      image: const AssetImage('images/profileImg6.png'),
                      icon: iconNum.value == 6 ? Icons.check : null,
                      onTap: () {
                        iconNum.value = 6;
                        Navigator.pop(context);
                      }),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
