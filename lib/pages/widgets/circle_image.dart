import 'package:flutter/material.dart';
import '../../helpers/constants.dart';

class CircleImage extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback? onTap;
  final IconData? icon;

  const CircleImage({required this.image, this.icon, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(context),
          if (icon != null)
            Positioned(bottom: 0, right: 2, child: buildIcon(mainColor)),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Theme.of(context).highlightColor,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 140,
          height: 140,
        ),
      ),
    );
  }

  Widget buildIcon(Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: buildCircle(
          padding: 3,
          color: Colors.white,
          child: buildCircle(
            padding: 8,
            color: color,
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          )),
    );
  }

  Widget buildCircle({
    required double padding,
    required Color color,
    required Widget child,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(padding),
        color: color,
        child: child,
      ),
    );
  }
}
