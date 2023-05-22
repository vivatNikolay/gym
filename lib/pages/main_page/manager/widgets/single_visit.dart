import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 2),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Разовое посещение',
            style: TextStyle(fontSize: 17),
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
                  textConfirmation: 'Добавить разовое?',
                  onYes: () async => _addSingleVisit(
                      userId, context),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Future<void> _addSingleVisit(String userId, BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    await _visitFire.create(Visit(date: DateTime.now(), userId: userId));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавлено разовое посещение')));
    Navigator.of(context).pop();
  }
}
