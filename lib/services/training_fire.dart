import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/training.dart';
import 'fire.dart';

class TrainingFire extends Fire<Training> {
  final dbName = 'trainings';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> create(Training training) async {
    training.userId = _firebaseAuth.currentUser!.uid;
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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByUser() {
    return firestore
        .collection(dbName)
        .where('userId', isEqualTo: _firebaseAuth.currentUser!.uid)
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