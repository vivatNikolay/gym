import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final VoidCallback onTap;

  const SearchField({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color? color = Theme.of(context).textTheme.bodyMedium!.color;
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: color ?? Colors.white54,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Поиск', style: TextStyle(fontSize: 18),),
            Icon(
              Icons.search,
              color: color,
              size: 28,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
