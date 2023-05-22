import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/membership.dart';
import 'fire.dart';

class MembershipFire extends Fire<Membership> {
  final dbName = 'memberships';

  @override
  Future<void> create(Membership membership) async {
    await firestore.collection(dbName).add(membership.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<Membership> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return Membership.fromDocument(doc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByUser(String userId) {
    return firestore
        .collection(dbName)
        .where('userId', isEqualTo: userId)
        .orderBy('creationDate', descending: true)
        .limit(1)
        .snapshots();
  }

  @override
  Future<void> put(Membership membership) async {
    await firestore
        .collection(dbName)
        .doc(membership.id)
        .update(membership.toMap());
  }
}