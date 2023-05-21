import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/training.dart';
import 'fire.dart';

class TrainingFire extends Fire<Training> {
  final dbName = 'trainings';

  @override
  Future<void> create(Training training) async {
    await firestore.collection(dbName).add(training.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<Training> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return Training.fromDocument(doc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByUser(String userId) {
    return firestore
        .collection(dbName)
        .where('userId', isEqualTo: userId)
        .orderBy('creationDate')
        .snapshots();
  }

  @override
  Future<void> put(Training training) async {
    await firestore
        .collection(dbName)
        .doc(training.id)
        .update(training.toMap());
  }
}