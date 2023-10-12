import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../services/exercise_fire.dart';
import '../../services/training_fire.dart';
import '../../pages/training_list/training_edit.dart';
import '../../models/training.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/confirm_dialog.dart';
import 'widgets/add_training_dialog.dart';
import 'widgets/training_card.dart';
import '../widgets/floating_add_button.dart';

final TrainingFire _trainingFire = TrainingFire();
final ExerciseFire _exerciseFire = ExerciseFire();

class TrainingList extends StatelessWidget {

  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'trainings'.i18n(),
      floatingActionButton: FloatingAddButton(
        text: 'addTraining'.i18n(),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTrainingDialog(),
        ),
      ),
      body: StreamBuilder(
          stream: _trainingFire.streamByUser(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapTraining) {
            if (snapTraining.hasError) {
              return Center(child: Text('trainingDidNotLoad'.i18n()));
            }
            if (snapTraining.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Training> trainings = List.from(snapTraining.data!.docs)
                .map((i) => Training.fromDocument(i))
                .toList();
            return SingleChildScrollView(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 80),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trainings.length,
                itemBuilder: (_, index) => StreamBuilder(
                    stream: _exerciseFire.streamByTrainingId(trainings[index].id),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> snapExercise) {
                      return TrainingCard(
                        title: trainings[index].name,
                        subtitle:
                            '${snapExercise.data != null ? snapExercise.data!.size : ' '} ${'exercises'.i18n()}',
                        onDelete: () =>
                            deletionDialog(context, trainings[index].id),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TrainingEdit(
                                  trainings[index].id!, trainings[index].name)));
                        },
                      );
                    }),
              ),
            );
          }),
    );
  }

  deletionDialog(BuildContext context, String? trainingId) => showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          onYes: () async {
            await _trainingFire.delete(trainingId);
            Navigator.of(context).pop();
          },
        ),
      );
}
