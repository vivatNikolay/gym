import 'package:cloud_firestore/cloud_firestore.dart';


class Training {
  String id;
  String name;

  Training({
    required this.id,
    required this.name
  });

  factory Training.fromDocument(DocumentSnapshot doc) {

    return Training(
      id: doc.id,
      name: doc.data().toString().contains('name') ? doc.get('name') : ''
    );
  }
}