import 'package:hive/hive.dart';

part 'training_settings.g.dart';

@HiveType(typeId: 6)
class TrainingSettings extends HiveObject {
  @HiveField(0)
  int defaultExerciseSets;
  @HiveField(1)
  int defaultExerciseReps;

  TrainingSettings({
    this.defaultExerciseSets = 5,
    this.defaultExerciseReps = 10
  });
}
