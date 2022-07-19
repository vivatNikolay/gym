import 'package:hive/hive.dart';
import 'package:sportmen_in_gym/models/subscription.dart';

part 'sportsman.g.dart';

@HiveType(typeId:0)
class Sportsman extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String password;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String firstName;
  @HiveField(5)
  DateTime dateOfBirth;
  @HiveField(6)
  Subscription? subscription;

  Sportsman({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.dateOfBirth,
    this.subscription
  });

  factory Sportsman.fromJson(Map<String, dynamic> json) {
    Subscription? subscription = Subscription.fromJson(json["subscription"]);

    return Sportsman(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        firstName: json["firstName"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"].toString()),
        subscription: subscription
    );
  }

  @override
  String toString() {
    return 'Sportsman{'
        'id: $id, email: $email, password: $password, phone: $phone, '
        'firstName: $firstName, dateOfBirth: $dateOfBirth, '
        'subscription: $subscription'
        '}';
  }
}