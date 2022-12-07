import 'package:flutter/material.dart';

class SettingPack extends StatelessWidget {
  List<Widget> children;

  SettingPack({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
