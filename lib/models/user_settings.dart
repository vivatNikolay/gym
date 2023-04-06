import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 6)
class UserSettings extends HiveObject {
  @HiveField(0)
  int defaultExerciseSets;
  @HiveField(1)
  int defaultExerciseReps;
  @HiveField(2)
  int defaultMembershipTime;
  @HiveField(3)
  int defaultMembershipNumber;

  UserSettings({
    this.defaultExerciseSets = 5,
    this.defaultExerciseReps = 10,
    this.defaultMembershipTime = 1,
    this.defaultMembershipNumber = 10
  });
}
