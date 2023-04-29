import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? id;
  String name;
  int reps;
  int sets;
  double? weight;
  double? duration;

  Exercise({
    this.id,
    required this.name,
    required this.reps,
    required this.sets,
    this.weight,
    this.duration
  });

  factory Exercise.fromDocument(DocumentSnapshot doc) {
    return Exercise(
      id: doc.id,
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      reps: doc.data().toString().contains('reps') ? doc.get('reps') : 0,
      sets: doc.data().toString().contains('sets') ? doc.get('sets') : 0,
      weight: doc.get('weight'),
      duration: doc.get('duration'),
    );
  }
}