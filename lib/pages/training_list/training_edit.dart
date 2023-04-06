import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../../models/user_settings.dart';
import '../../models/training.dart';
import '../../services/db/training_db_service.dart';
import '../../pages/training_list/exercise_edit.dart';
import '../../pages/training_list/widgets/floating_add_button.dart';
import '../../services/providers/user_settings_provider.dart';
import 'widgets/training_card.dart';

class TrainingEdit extends StatefulWidget {
  final Training training;

  const TrainingEdit({required this.training, Key? key}) : super(key: key);

  @override
  State<TrainingEdit> createState() => _TrainingEditState();
}

class _TrainingEditState extends State<TrainingEdit> {
  late Training training;
  final TrainingDBService _dbService = TrainingDBService();
  late List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    training = widget.training;
    _exercises = training.exercises;
  }

  @override
  Widget build(BuildContext context) {
    final UserSettings _settings = Provider.of<UserSettingsPr>(context, listen: false).settings;

    return WillPopScope(
      onWillPop: () {
        return _dbService.saveOrUpdate(training);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(trainingListImage),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            opacity: 0.6,
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(training.name),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingAddButton(
            text: 'Добавить упражнение',
            onPressed: () async {
              ValueNotifier<Exercise> newExercise = ValueNotifier(Exercise(
                  name: '',
                  reps: _settings.defaultExerciseReps,
                  sets: _settings.defaultExerciseSets));
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseEdit(exercise: newExercise)));
              setState(() {
                if (newExercise.value.name.isNotEmpty) {
                  _exercises.add(newExercise.value);
                }
              });
            },
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: buildList(context),
          )),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    if (_exercises.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _exercises.length,
        itemBuilder: (_, index) {
          return TrainingCard(
            title: _exercises[index].name,
            subtitle: '${_exercises[index].reps} / ${_exercises[index].sets}',
            onDelete: () => setState(() {
              _exercises.remove(_exercises[index]);
            }),
            onTap: () async {
              ValueNotifier<Exercise> exercise =
              ValueNotifier(_exercises[index]);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseEdit(exercise: exercise)));
              setState(() {
                _exercises[index] = exercise.value;
              });
            },
          );
        });
  }
}
