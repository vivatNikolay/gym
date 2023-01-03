import 'package:hive/hive.dart';

part 'visit.g.dart';

@HiveType(typeId: 7)
class Visit extends HiveObject{
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toString().substring(0, 10)
  };

  @override
  String toString() {
    return 'Visit{'
        'id: $id, date: $date'
        '}';
  }
}
