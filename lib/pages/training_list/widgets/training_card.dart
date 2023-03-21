import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class TrainingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TrainingCard(
      {required this.title,
      required this.subtitle,
      this.onDelete,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.9),
      elevation: 3.0,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: SizedBox(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: mainColor, width: 10),
              ),
            ),
            child: ListTile(
              minLeadingWidth: 24,
              title: Text(title, style: const TextStyle(fontSize: 19)),
              subtitle: Text(subtitle),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
