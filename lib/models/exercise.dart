import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 4)
class Exercise extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  int reps;
  @HiveField(2)
  int sets;
  @HiveField(3)
  double? weight;
  @HiveField(4)
  double? duration;

  Exercise({
    required this.name,
    required this.reps,
    required this.sets,
    this.weight,
    this.duration
  });
}