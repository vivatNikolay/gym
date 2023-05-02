import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings {
  int defaultExerciseSets;
  int defaultExerciseReps;
  int defaultMembershipTime;
  int defaultMembershipNumber;

  UserSettings(
      {required this.defaultExerciseSets,
      required this.defaultExerciseReps,
      required this.defaultMembershipTime,
      required this.defaultMembershipNumber});

  factory UserSettings.fromDocument(DocumentSnapshot doc) {
    return UserSettings(
      defaultExerciseSets: doc.data().toString().contains('defaultExerciseSets') ? doc.get('defaultExerciseSets') : 5,
      defaultExerciseReps: doc.data().toString().contains('defaultExerciseReps') ? doc.get('defaultExerciseReps') : 10,
      defaultMembershipTime: doc.data().toString().contains('defaultMembershipTime') ? doc.get('defaultMembershipTime') : 1,
      defaultMembershipNumber: doc.data().toString().contains('defaultMembershipNumber') ? doc.get('defaultMembershipNumber') : 10,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettings &&
          runtimeType == other.runtimeType &&
          defaultExerciseSets == other.defaultExerciseSets &&
          defaultExerciseReps == other.defaultExerciseReps &&
          defaultMembershipTime == other.defaultMembershipTime &&
          defaultMembershipNumber == other.defaultMembershipNumber;

  @override
  int get hashCode =>
      defaultExerciseSets.hashCode ^
      defaultExerciseReps.hashCode ^
      defaultMembershipTime.hashCode ^
      defaultMembershipNumber.hashCode;
}
