import 'package:hive/hive.dart';

import 'exercise.dart';

part 'training.g.dart';

@HiveType(typeId: 4)
class Training extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Exercise> exercises;

  Training({
    required this.name,
    required this.exercises
  });
}