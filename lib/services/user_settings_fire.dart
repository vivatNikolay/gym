import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_settings.dart';
import 'fire.dart';

class UserSettingsFire extends Fire<UserSettings> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final dbName = 'userSettings';

  @override
  Future<void> create(UserSettings userSettings) async {
    await firestore.collection(dbName).add(userSettings.toMap());
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<UserSettings> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(id).get();
    return UserSettings.fromDocument(doc);
  }

  Future<UserSettings> init() async {
    DocumentSnapshot doc = await firestore.collection(dbName)
        .doc(_firebaseAuth.currentUser!.uid).get();
    return UserSettings.fromDocument(doc);
  }

  @override
  Future<void> put(UserSettings userSettings) async {
    await firestore
        .collection(dbName)
        .doc(_firebaseAuth.currentUser!.uid)
        .set(userSettings.toMap());
  }
}