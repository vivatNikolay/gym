import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Account extends HiveObject{
  String? id;
  String email;
  String lastName;
  String phone;
  String firstName;
  bool gender;
  int iconNum;
  DateTime dateOfBirth;
  String role;

  Account({
    this.id,
    required this.email,
    required this.lastName,
    required this.phone,
    required this.firstName,
    required this.gender,
    required this.iconNum,
    required this.dateOfBirth,
    required this.role
  });

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account(
      id: doc.id,
      email: doc.data().toString().contains('email') ? doc.get('email') : '',
      lastName: doc.data().toString().contains('lastName') ? doc.get('lastName') : '',
      phone: doc.data().toString().contains('phone') ? doc.get('phone') : '',
      firstName: doc.data().toString().contains('firstName') ? doc.get('firstName') : '',
      gender: doc.data().toString().contains('gender') ? doc.get('gender') : true,
      iconNum: doc.data().toString().contains('iconNum') ? doc.get('iconNum') : 1,
      dateOfBirth: doc.data().toString().contains('dateOfBirth') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfBirth')) : DateTime.now(),
      role: doc.data().toString().contains('role') ? doc.get('role') : '',
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'lastName': lastName,
    'phone': phone,
    'firstName': firstName,
    'gender': gender,
    'iconNum': iconNum,
    'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
    'role': role,
  };

  @override
  String toString() {
    return 'Account{id: $id, email: $email, lastName: $lastName,'
        ' phone: $phone, firstName: $firstName, gender: $gender,'
        ' iconNum: $iconNum, dateOfBirth: $dateOfBirth, role: $role}';
  }
}