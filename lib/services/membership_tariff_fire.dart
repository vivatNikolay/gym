import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/membership_tariff.dart';
import 'fire.dart';

class MembershipTariffFire extends Fire<MembershipTariff> {
  final dbName = 'membershipTariff';

  @override
  Future<void> create(MembershipTariff membershipTariff) async {
    await firestore.collection(dbName).add(membershipTariff.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<MembershipTariff> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return MembershipTariff.fromDocument(doc);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    return firestore
        .collection(dbName)
        .orderBy('order')
        .snapshots();
  }

  @override
  Future<void> put(MembershipTariff membershipTariff) async {
    await firestore
        .collection(dbName)
        .doc(membershipTariff.id)
        .update(membershipTariff.toMap());
  }
}