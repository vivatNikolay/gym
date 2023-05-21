import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings {
  String? id;
  int defaultExerciseSets;
  int defaultExerciseReps;
  int defaultMembershipTime;
  int defaultMembershipNumber;

  UserSettings(
      {this.id,
      required this.defaultExerciseSets,
      required this.defaultExerciseReps,
      required this.defaultMembershipTime,
      required this.defaultMembershipNumber});

  factory UserSettings.fromDocument(DocumentSnapshot doc) {
    return UserSettings(
      id: doc.id,
      defaultExerciseSets: doc.data().toString().contains('defaultExerciseSets') ? doc.get('defaultExerciseSets') : 5,
      defaultExerciseReps: doc.data().toString().contains('defaultExerciseReps') ? doc.get('defaultExerciseReps') : 10,
      defaultMembershipTime: doc.data().toString().contains('defaultMembershipTime') ? doc.get('defaultMembershipTime') : 1,
      defaultMembershipNumber: doc.data().toString().contains('defaultMembershipNumber') ? doc.get('defaultMembershipNumber') : 10,
    );
  }

  Map<String, dynamic> toMap() => {
    'defaultMembershipTime': defaultMembershipTime,
    'defaultMembershipNumber': defaultMembershipNumber,
    'defaultExerciseSets': defaultExerciseSets,
    'defaultExerciseReps': defaultExerciseReps,
  };
}
