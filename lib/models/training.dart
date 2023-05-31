import 'package:cloud_firestore/cloud_firestore.dart';


class Training {
  String? id;
  String name;
  String? userId;
  DateTime creationDate;

  Training({
    this.id,
    required this.name,
    this.userId,
    required this.creationDate,
  });

  factory Training.fromDocument(DocumentSnapshot doc) {
    return Training(
      id: doc.id,
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      userId: doc.data().toString().contains('userId') ? doc.get('userId') : null,
      creationDate: doc.data().toString().contains('creationDate') ? DateTime.fromMillisecondsSinceEpoch(doc.get('creationDate')) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'userId': userId,
    'creationDate': creationDate.millisecondsSinceEpoch,
  };
}