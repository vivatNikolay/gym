import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';

import '../models/account.dart';
import 'fire.dart';

class AccountFire extends Fire<Account> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final dbName = 'users';

  String currentUserId() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    }
    return '';
  }

  Future<String?> signup(String email, String pass) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    return userCredential.user?.uid;
  }

  @override
  Future<void> create(Account account) async {
    try {
      await firestore
          .collection(dbName)
          .doc(account.id)
          .set(account.toMap());
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'emailAlreadyInUse'.i18n();
      }
      throw 'userCreationError'.i18n();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'userNotFound'.i18n();
      }
      if (e.code == 'wrong-password') {
        throw 'wrongPassword'.i18n();
      }
      throw 'authError'.i18n();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> delete(String? id) async {
    await firestore.collection(dbName).doc(id).delete();
  }

  @override
  Future<Account> get(String? id) async {
    DocumentSnapshot doc = await firestore.collection(dbName).doc(id).get();
    return Account.fromDocument(doc);
  }

  Future<Account> init() async {
    DocumentSnapshot doc = await firestore.collection(dbName).doc(_firebaseAuth.currentUser!.uid).get();
    return Account.fromDocument(doc);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream() {
    return firestore
        .collection(dbName)
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  @override
  Future<void> put(Account account) async {
    try {
      await firestore.collection(dbName).doc(account.id).update(
          account.toMap());
    } catch (e) {
      throw 'userEditingError'.i18n();
    }
  }

  Future<QuerySnapshot> findByQuery(String email) async {
    // search by query isn't free:(
    return firestore.collection(dbName).where('email', isEqualTo: email).get();
  }

  Future<void> resetPass(Account? account) async {
    if (account != null) {
      // await _firebaseAuth.sendPasswordResetEmail(email: email);
    }
  }

  Future<void> updatePass(String newPassword) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        throw 'passwordLengthLessThanSix'.i18n();
      }
      throw e.message ?? 'weakPassword'.i18n();
    }
  }
}
