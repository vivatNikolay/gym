import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../../models/user_settings.dart';
import '../../models/training.dart';
import '../../pages/training_list/exercise_edit.dart';
import '../../pages/training_list/widgets/floating_add_button.dart';
import '../../providers/training_provider.dart';
import '../../providers/user_settings_provider.dart';
import 'widgets/training_card.dart';

class TrainingEdit extends StatelessWidget {
  final int trainingKey;

  const TrainingEdit(this.trainingKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserSettings _settings =
        Provider.of<UserSettingsPr>(context, listen: false).settings;
    final Training training =
        Provider.of<TrainingPr>(context).findByKey(trainingKey);
    List<Exercise> exercises = training.exercises;

    return Container(
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
            await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ExerciseEdit(exercise: newExercise)));

            if (newExercise.value.name.isNotEmpty) {
              exercises.add(newExercise.value);
              Provider.of<TrainingPr>(context, listen: false).put(training);
            }
          },
        ),
        body: SingleChildScrollView(
            child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                itemBuilder: (_, index) {
                  return TrainingCard(
                    title: exercises[index].name,
                    subtitle:
                        '${exercises[index].reps} / ${exercises[index].sets}',
                    onDelete: () {
                      exercises.remove(exercises[index]);
                      Provider.of<TrainingPr>(context, listen: false)
                          .put(training);
                    },
                    onTap: () async {
                      ValueNotifier<Exercise> exercise =
                          ValueNotifier(exercises[index]);
                      await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ExerciseEdit(exercise: exercise)));
                      exercises[index] = exercise.value;
                      Provider.of<TrainingPr>(context, listen: false)
                          .put(training);
                    },
                  );
                })),
      ),
    );
  }
}
