import 'package:hive/hive.dart';

import 'visit.dart';

part 'subscription.g.dart';

@HiveType(typeId: 1)
class Subscription {
  @HiveField(0)
  int id;
  @HiveField(1)
  DateTime dateOfStart;
  @HiveField(2)
  DateTime dateOfEnd;
  @HiveField(3)
  int numberOfVisits;
  @HiveField(4)
  List<Visit> visits = List.empty();

  Subscription({
    required this.id,
    required this.dateOfStart,
    required this.dateOfEnd,
    required this.numberOfVisits,
    required this.visits
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    List<Visit> visits = (List.from(json["visits"])).map((i) => Visit.fromJson(i)).toList();

    return Subscription(
      id : json["id"],
      dateOfStart : DateTime.parse(json["dateOfStart"].toString()),
      dateOfEnd : DateTime.parse(json["dateOfEnd"].toString()),
      numberOfVisits : json["numberOfVisits"],
      visits: visits,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'dateOfStart': dateOfStart.toString().substring(0, 10),
      'dateOfEnd': dateOfEnd.toString().substring(0, 10),
      'numberOfVisits': numberOfVisits,
      'visits': visits.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() {
    return 'Subscription{'
        'id: $id, dateOfStart: $dateOfStart, dateOfEnd: $dateOfEnd, '
        'numberOfVisits: $numberOfVisits, visitCounter: $visits'
        '}';
  }
}
