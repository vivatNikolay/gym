import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../pages/training_list/training_edit.dart';
import '../../models/training.dart';
import '../../providers/training_provider.dart';
import '../widgets/my_text_field.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/confirm_dialog.dart';
import 'widgets/training_card.dart';
import 'widgets/floating_add_button.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Training> trainings = Provider.of<TrainingPr>(context).trainings;

    return MainScaffold(
      title: 'Тренировки',
      floatingActionButton: FloatingAddButton(
        text: 'Добавить тренировку',
        onPressed: () => creationDialog(context),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 80),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trainings.length,
          itemBuilder: (_, index) => TrainingCard(
            title: trainings[index].name,
            subtitle:
                '${trainings[index].exercises.length.toString()} упражнений',
            onDelete: () => deletionDialog(context, trainings[index]),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TrainingEdit(trainings[index].key)));
            },
          ),
        ),
      ),
    );
  }

  Future creationDialog(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    ValueNotifier<bool> _nameValidator = ValueNotifier(true);
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Тренировка'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                content: MyTextField(
                  autofocus: true,
                  fieldName: 'Название',
                  controller: _nameController,
                  validation: _nameValidator,
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                actions: [
                  TextButton(
                    child: const Text('Добавить',
                        style: TextStyle(color: mainColor, fontSize: 18)),
                    onPressed: () async {
                      setState(() => _nameValidator.value =
                          _nameController.text.isNotEmpty);
                      if (_nameValidator.value) {
                        Provider.of<TrainingPr>(context, listen: false)
                            .put(Training(
                          name: _nameController.text.trim(),
                          exercises: List.empty(growable: true),
                        ));
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ));
  }

  deletionDialog(BuildContext context, Training training) => showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          onNo: () => Navigator.pop(context),
          onYes: () {
            Provider.of<TrainingPr>(context, listen: false).delete(training);
            Navigator.pop(context);
          },
        ),
      );
}
