import 'package:hive/hive.dart';

part 'visit.g.dart';

@HiveType(typeId:2)
class Visit {
  @HiveField(0)
  int id;
  @HiveField(1)
  DateTime date;

  Visit({
    required this.id,
    required this.date
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
        id: json["id"],
        date: DateTime.parse(json["date"].toString()),
    );
  }

  @override
  String toString() {
    return 'Visit{'
        'id: $id, date: $date'
        '}';
  }
}
