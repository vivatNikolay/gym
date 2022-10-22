import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../../models/training_settings.dart';
import '../../models/training.dart';
import '../../services/db/training_settings_db_service.dart';
import '../../services/db/training_db_service.dart';
import '../../pages/training_list/exercise_edit.dart';
import '../../pages/training_list/widgets/add_button.dart';

class TrainingEdit extends StatefulWidget {
  final Training training;

  const TrainingEdit({required this.training, Key? key}) : super(key: key);

  @override
  State<TrainingEdit> createState() => _TrainingEditState(training);
}

class _TrainingEditState extends State<TrainingEdit> {
  final Training training;
  final TrainingDBService _dbService = TrainingDBService();
  final TrainingSettings _settings = TrainingSettingsDBService().getFirst();
  late List<Exercise> _exercises;

  _TrainingEditState(this.training);

  @override
  void initState() {
    super.initState();

    _exercises = training.exercises;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _dbService.saveOrUpdate(training);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(training.name),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(trainingListImage),
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              opacity: 0.6,
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
            child: Column(
              children: [
                buildList(context),
                AddButton(
                  text: 'Add exercise',
                  onTap: () async {
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
                      _exercises.add(newExercise.value);
                    });
                  },
                  highlightColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
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
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            elevation: 4.0,
            child: ListTile(
              title: Text(_exercises[index].name,
                  style: const TextStyle(fontSize: 19)),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _exercises.remove(_exercises[index]);
                  });
                },
              ),
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
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        });
  }
}
