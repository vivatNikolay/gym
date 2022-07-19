import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId:1)
class Subscription {
  @HiveField(0)
  int id;
  @HiveField(1)
  DateTime dateOfPurchase;
  @HiveField(2)
  DateTime dateOfEnd;
  @HiveField(3)
  int numberOfVisits;
  @HiveField(4)
  int visitCounter;

  Subscription({
    required this.id,
    required this.dateOfPurchase,
    required this.dateOfEnd,
    required this.numberOfVisits,
    required this.visitCounter
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id : json["id"],
      dateOfPurchase : DateTime.parse(json["dateOfPurchase"].toString()),
      dateOfEnd : DateTime.parse(json["dateOfEnd"].toString()),
      numberOfVisits : json["numberOfVisits"],
      visitCounter: json["visitCounter"],
    );
  }

  @override
  String toString() {
    return 'Subscription{'
        'id: $id, dateOfPurchase: $dateOfPurchase, dateOfEnd: $dateOfEnd, '
        'numberOfVisits: $numberOfVisits, visitCounter: $visitCounter'
        '}';
  }
}
