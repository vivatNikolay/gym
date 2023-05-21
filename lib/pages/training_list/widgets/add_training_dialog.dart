import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/training.dart';
import '../../../services/training_fire.dart';
import '../../../helpers/constants.dart';
import '../../../providers/account_provider.dart';
import '../../widgets/my_text_field.dart';

class AddTrainingDialog extends StatelessWidget {
  final TrainingFire _trainingFire = TrainingFire();

  AddTrainingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountId =
        Provider.of<AccountPr>(context, listen: false).account!.id;
    TextEditingController _nameController = TextEditingController();
    return AlertDialog(
      title: const Text('Тренировка'),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: MyTextField(
        autofocus: true,
        fieldName: 'Название',
        controller: _nameController,
        validation: ValueNotifier(true),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          child: const Text('Добавить',
              style: TextStyle(color: mainColor, fontSize: 18)),
          onPressed: () async {
            if (_nameController.text.trim().isNotEmpty) {
              _trainingFire.create(Training(
                  name: _nameController.text,
                  userId: accountId,
                  creationDate: DateTime.now()));
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
