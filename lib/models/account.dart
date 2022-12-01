import 'package:hive/hive.dart';
import 'package:sportmen_in_gym/models/subscription.dart';

part 'account.g.dart';

@HiveType(typeId:0)
class Account extends HiveObject{
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
    required this.id,
    required this.email,
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
        'id: $id, email: $email, password: $password, phone: $phone, '
        'firstName: $firstName, gender: $gender, iconNum: $iconNum,'
        ' dateOfBirth: $dateOfBirth, subscription: $subscriptions},'
        'role: $role';
  }
}