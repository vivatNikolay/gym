import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  String text;
  VoidCallback? onTap;
  Color highlightColor;

  AddButton({
    required this.text,
    required this.highlightColor,
    this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        elevation: 2.0,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              Text(text, style: const TextStyle(fontSize: 19)),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: onTap,
      highlightColor: highlightColor,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
