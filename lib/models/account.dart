import 'package:hive/hive.dart';

import '../models/subscription.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String password;
  @HiveField(4)
  String phone;
  @HiveField(5)
  String firstName;
  @HiveField(6)
  bool gender;
  @HiveField(7)
  int iconNum;
  @HiveField(8)
  DateTime dateOfBirth;
  @HiveField(9)
  List<Subscription> subscriptions = List.empty();
  @HiveField(10)
  String role;

  Account({
    required this.id,
    required this.email,
    required this.lastName,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.gender,
    required this.iconNum,
    required this.dateOfBirth,
    required this.subscriptions,
    required this.role
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    List<Subscription> subscriptions = (List.from(json["subscriptions"]))
        .map((i) => Subscription.fromJson(i))
        .toList();

    return Account(
        id: json["id"],
        email: json["email"],
        lastName: json["lastName"],
        password: json["password"],
        phone: json["phone"],
        firstName: json["firstName"],
        gender: json["gender"],
        iconNum: json["iconNum"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"].toString()),
        subscriptions: subscriptions,
        role: json["role"]
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'email': email,
      'lastName': lastName,
      'password': password,
      'phone': phone,
      'firstName': firstName,
      'gender': gender,
      'iconNum': iconNum,
      'dateOfBirth': dateOfBirth.toString().substring(0, 10),
      'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
      'role': role
  };

  @override
  String toString() {
    return 'Account{'
        'id: $id, email: $email, lastName: $lastName, password: $password, phone: $phone, '
        'firstName: $firstName, gender: $gender, iconNum: $iconNum,'
        ' dateOfBirth: $dateOfBirth, subscription: $subscriptions},'
        'role: $role';
  }
}