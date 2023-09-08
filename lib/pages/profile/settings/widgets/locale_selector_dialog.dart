import 'package:flutter/material.dart';
import '../../../../models/available_locale.dart';


class LocaleSelectorDialog extends StatelessWidget {
  final List<dynamic> _items = AvailableLocale.values;
  final int selection;
  final Function(int lang) action;

  LocaleSelectorDialog(
      {required this.selection, required this.action, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<int>(
                  value: _items.indexOf(_items[index]),
                  onChanged: (int? value) {
                    if (value != null) {
                      action(value);
                      Navigator.pop(context);
                    }
                  },
                  title: Text(_items[index]['title']),
                  groupValue: selection,
                );
              }),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
    );
  }
}