import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../pages/training_list/training_edit.dart';
import '../../pages/training_list/widgets/add_button.dart';
import '../../services/db/training_db_service.dart';
import '../../models/training.dart';
import '../widgets/my_text_field.dart';
import '../widgets/confirm_dialog.dart';

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
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(trainingListImage),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          opacity: 0.6,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildList(context),
            AddButton(
              text: 'Add training',
              onTap: () => creationDialog(),
              highlightColor: Colors.black,
            ),
          ],
        ),
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
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            elevation: 2.0,
            child: ListTile(
              title: Text('${_trainings[index].name}',
                  style: const TextStyle(fontSize: 19)),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deletionDialog(index),
              ),
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
            ),
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
              title: const Text('Training'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              content: MyTextField(
                autofocus: true,
                hintText: 'Name',
                controller: _nameController,
                validation: _nameValidator,
                inBox: false,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: [
                TextButton(
                  child: const Text('Add',
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
