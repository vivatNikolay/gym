import 'package:hive/hive.dart';

part 'visit.g.dart';

@HiveType(typeId: 2)
class Visit extends HiveObject{
  @HiveField(0)
  DateTime date;

  Visit({
    required this.date
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
        date: DateTime.parse(json["date"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toString().substring(0, 10)
  };

  @override
  String toString() {
    return 'Visit{date: $date}';
  }
}
