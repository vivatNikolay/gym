import 'package:hive/hive.dart';

import '../models/subscription.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject{
  @HiveField(0)
  String email;
  @HiveField(1)
  String lastName;
  @HiveField(2)
  String password;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String firstName;
  @HiveField(5)
  bool gender;
  @HiveField(6)
  int iconNum;
  @HiveField(7)
  DateTime dateOfBirth;
  @HiveField(8)
  List<Subscription> subscriptions = List.empty();
  @HiveField(9)
  String role;

  Account({
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

  factory Account.emptySportsman() {
    return Account(email: '', lastName: '', password: '', phone: '',
        firstName: '', gender: true, iconNum: 1, dateOfBirth: DateTime.utc(2000),
    subscriptions: List.empty(), role: 'USER');
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    List<Subscription> subscriptions = (List.from(json["subscriptions"]))
        .map((i) => Subscription.fromJson(i))
        .toList();

    return Account(
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
        'email: $email, lastName: $lastName, password: $password, phone: $phone, '
        'firstName: $firstName, gender: $gender, iconNum: $iconNum,'
        ' dateOfBirth: $dateOfBirth, subscription: $subscriptions},'
        'role: $role';
  }
}