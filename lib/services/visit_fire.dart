import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/visit.dart';
import 'fire.dart';

class VisitFire extends Fire<Visit> {
  final dbName = 'visits';

  @override
  Future<void> create(Visit visit) async {
    await firestore.collection(dbName).add(visit.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<Visit> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return Visit.fromDocument(doc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByUser(String userId) {
    return firestore
        .collection(dbName)
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByUserAndMembership(String userId, String membershipId) {
    return firestore
        .collection(dbName)
        .where('userId', isEqualTo: userId)
        .where('membershipId', isEqualTo: membershipId)
        .orderBy('date')
        .snapshots();
  }

  @override
  Future<void> put(Visit visit) async {
    await firestore
        .collection(dbName)
        .doc(visit.id)
        .update(visit.toMap());
  }
}