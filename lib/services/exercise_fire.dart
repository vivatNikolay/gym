import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';
import 'fire.dart';

class ExerciseFire extends Fire<Exercise> {
  final dbName = 'exercises';

  @override
  Future<void> create(Exercise exercise) async {
    await firestore.collection(dbName).add(exercise.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<Exercise> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return Exercise.fromDocument(doc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByTrainingId(String? trainingId) {
    return firestore
        .collection(dbName)
        .where('trainingId', isEqualTo: trainingId)
        .orderBy('creationDate')
        .snapshots();
  }

  @override
  Future<void> put(Exercise exercise) async {
    await firestore
        .collection(dbName)
        .doc(exercise.id)
        .update(exercise.toMap());
  }
}