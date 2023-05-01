import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/training_list/training_edit.dart';
import '../../models/training.dart';
import '../../providers/account_provider.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/confirm_dialog.dart';
import 'widgets/add_training_dialog.dart';
import 'widgets/training_card.dart';
import 'widgets/floating_add_button.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountId =
        Provider.of<AccountPr>(context, listen: false).account!.id;

    return MainScaffold(
      title: 'Тренировки',
      floatingActionButton: FloatingAddButton(
        text: 'Добавить тренировку',
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTrainingDialog(),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('trainings')
              .where('userId', isEqualTo: accountId)
              .orderBy('creationDate')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapTraining) {
            if (snapTraining.hasError) {
              return const Center(child: Text('Тренировки не загрузились'));
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
                    stream: FirebaseFirestore.instance
                        .collection('trainings')
                        .doc(trainings[index].id)
                        .collection('exercises')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> snapExercise) {
                      return TrainingCard(
                        title: trainings[index].name,
                        subtitle:
                            '${snapExercise.data != null ? snapExercise.data!.size : 0} упражнений',
                        onDelete: () =>
                            deletionDialog(context, trainings[index].id),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TrainingEdit(
                                  trainings[index].id, trainings[index].name)));
                        },
                      );
                    }),
              ),
            );
          }),
    );
  }

  deletionDialog(BuildContext context, String trainingId) => showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          onNo: () => Navigator.of(context).pop(),
          onYes: () async {
            await FirebaseFirestore.instance
                .collection('trainings')
                .doc(trainingId)
                .delete();
            Navigator.of(context).pop();
          },
        ),
      );
}
