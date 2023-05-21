import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Fire<T> {
  final firestore = FirebaseFirestore.instance;

  Future<void> create(T t);
  Future<void> delete(String? id);
  Future<T> get(String? id);
  Future<void> put(T t);
}