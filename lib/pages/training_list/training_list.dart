import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../pages/training_list/training_edit.dart';
import '../../services/db/training_db_service.dart';
import '../../models/training.dart';
import '../widgets/my_text_field.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/confirm_dialog.dart';
import 'widgets/training_card.dart';
import 'widgets/floating_add_button.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  final TrainingDBService _dbService = TrainingDBService();
  late List<Training> _trainings;
  late TextEditingController _nameController;
  late ValueNotifier<bool> _nameValidator;

  @override
  void initState() {
    super.initState();

    _trainings = _dbService.getAll();

    _nameController = TextEditingController();
    _nameValidator = ValueNotifier(true);
  }

  @override
  void dispose() {
    _nameValidator.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Тренировки',
      floatingActionButton: FloatingAddButton(
        text: 'Добавить тренировку',
        onPressed: () => creationDialog(),
      ),
      body: SingleChildScrollView(
        child: buildList(context),
        padding: const EdgeInsets.only(top: 10),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    if (_trainings.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _trainings.length,
        itemBuilder: (_, index) {
          return TrainingCard(
              title: _trainings[index].name,
            subtitle: '${_trainings[index].exercises.length.toString()} упражнений',
            onDelete: () => deletionDialog(index),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TrainingEdit(training: _trainings[index])));
              setState(() {
                _trainings = _dbService.getAll();
              });
            },
          );
        });
  }

  Future creationDialog() {
    _nameValidator.value = true;
    _nameController.clear();
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
                    setState(() =>
                        _nameValidator.value = _nameController.text.isNotEmpty);
                    if (_nameValidator.value) {
                      Navigator.pop(context);
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingEdit(
                                  training: Training(
                                      name: _nameController.text.trim(),
                                      exercises: List.empty(growable: true)))));
                      this.setState(() {
                        _trainings = _dbService.getAll();
                      });
                    }
                  },
                )
              ],
            ),
          ));
  }

  deletionDialog(int index) => showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          onNo: () => Navigator.pop(context),
          onYes: () async {
            _dbService.delete(_trainings[index]);
            setState(() {
              _trainings = _dbService.getAll();
            });
            Navigator.pop(context);
          },
        ),
      );
}
