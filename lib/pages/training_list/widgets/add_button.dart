import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  String text;
  Function onTap;
  Color highlightColor;

  AddButton({
    required this.text,
    required this.onTap,
    required this.highlightColor,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
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
      onTap: () => onTap,
      highlightColor: highlightColor,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
