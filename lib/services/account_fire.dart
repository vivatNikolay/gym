import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Future<void> create(Account account) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword( //ВХОДИТ В АККАУНТ ПОСЛЕ СОЗДАНИЯ!!
              email: account.email, password: '111111');
      await firestore
          .collection(dbName)
          .doc(userCredential.user!.uid)
          .set(account.toMap());
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email уже используется';
      }
      throw 'Ошибка создания пользователя';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Пользователь не найден';
      }
      if (e.code == 'wrong-password') {
        throw 'Неверный пароль';
      }
      throw 'Ошибка аутентификации';
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
      throw 'Ошибка редактирования пользователя';
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
        throw 'Длина пароля меньше 6 символов';
      }
      throw e.message ?? 'Слабый пароль';
    }
  }
}
