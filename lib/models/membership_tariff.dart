import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipTariff {
  String? id;
  String name;
  int duration;
  int numberOfVisits;
  double price;
  int order;
  String? description;

  MembershipTariff({
    this.id,
    required this.name,
    required this.duration,
    required this.numberOfVisits,
    required this.price,
    required this.order,
    this.description,
  });

  factory MembershipTariff.fromDocument(DocumentSnapshot doc) {
    return MembershipTariff(
      id: doc.id,
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      duration: doc.data().toString().contains('duration') ? doc.get('duration') : 0,
      numberOfVisits: doc.data().toString().contains('numberOfVisits') ? doc.get('numberOfVisits') : 0,
      price: doc.data().toString().contains('price') ? doc.get('price') : 0.0,
      order: doc.data().toString().contains('order') ? doc.get('order') : 0,
      description: doc.data().toString().contains('description') ? doc.get('description') : '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'duration': duration,
    'numberOfVisits': numberOfVisits,
    'price': price,
    'order': order,
    'description': description,
  };
}
