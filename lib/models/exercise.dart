import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? id;
  String name;
  int reps;
  int sets;
  double? weight;
  double? duration;
  DateTime creationDate;
  String trainingId;

  Exercise({
    this.id,
    required this.name,
    required this.reps,
    required this.sets,
    this.weight,
    this.duration,
    required this.creationDate,
    required this.trainingId,
  });

  factory Exercise.fromDocument(DocumentSnapshot doc) {
    return Exercise(
      id: doc.id,
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      reps: doc.data().toString().contains('reps') ? doc.get('reps') : 0,
      sets: doc.data().toString().contains('sets') ? doc.get('sets') : 0,
      weight: doc.data().toString().contains('weight') ? doc.get('weight') : null,
      duration: doc.data().toString().contains('duration') ? doc.get('duration') : null,
      creationDate: doc.data().toString().contains('creationDate') ? DateTime.fromMillisecondsSinceEpoch(doc.get('creationDate')) : DateTime.now(),
      trainingId: doc.data().toString().contains('trainingId') ? doc.get('trainingId') : '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'reps': reps,
    'sets': sets,
    'weight': weight,
    'duration': duration,
    'creationDate': creationDate.millisecondsSinceEpoch,
    'trainingId': trainingId,
  };
}