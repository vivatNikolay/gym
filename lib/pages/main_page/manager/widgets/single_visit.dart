import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../../helpers/constants.dart';
import '../../../../models/visit.dart';
import '../../../../services/visit_fire.dart';
import '../../../widgets/confirm_dialog.dart';

class SingleVisit extends StatelessWidget {
  final VisitFire _visitFire = VisitFire();
  final String userId;
  SingleVisit({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'singleVisit'.i18n(),
            style: const TextStyle(fontSize: 17),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  textConfirmation: 'addSingleVisit'.i18n(),
                  onYes: () async => _addSingleVisit(
                      userId, context),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(size.width > 340 ? 'add'.i18n() : ''),
          ),
        ],
      ),
    );
  }

  Future<void> _addSingleVisit(String userId, BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    await _visitFire.create(Visit(date: DateTime.now(), userId: userId));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('singleVisitAdded'.i18n())));
    Navigator.of(context).pop();
  }
}
