import 'package:cloud_firestore/cloud_firestore.dart';

class Membership {
  String id;
  DateTime dateOfStart;
  DateTime dateOfEnd;
  int numberOfVisits;
  int visitCounter;

  Membership({
    required this.id,
    required this.dateOfStart,
    required this.dateOfEnd,
    required this.numberOfVisits,
    required this.visitCounter,
  });

  factory Membership.fromDocument(DocumentSnapshot doc) {
    return Membership(
        id: doc.id,
        dateOfStart: doc.data().toString().contains('dateOfStart') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfStart')) : DateTime.now(),
        dateOfEnd: doc.data().toString().contains('dateOfEnd') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfEnd')) : DateTime.now(),
        numberOfVisits: doc.data().toString().contains('numberOfVisits') ? doc.get('numberOfVisits') : 0,
        visitCounter: doc.data().toString().contains('visitCounter') ? doc.get('visitCounter') : 0,
    );
  }

  static Future<void> addMembership(String userId, int dateOfStart, int dateOfEnd, int numberOfVisits) async {
    await FirebaseFirestore.instance.collection('memberships').add({
      'userId': userId,
      'dateOfStart': dateOfStart,
      'dateOfEnd': dateOfEnd,
      'numberOfVisits': numberOfVisits,
      'visitCounter': 0,
    });
  }

  static Future<void> updateMembership(String membershipId, int visitCounter) async {
    await FirebaseFirestore.instance
        .collection('memberships')
        .doc(membershipId)
        .update({
      'visitCounter': visitCounter,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMembershipStreamByUser(
      String userId) {
    return FirebaseFirestore.instance
        .collection('memberships')
        .where('userId',
        isEqualTo: userId)
        .orderBy('dateOfEnd')
        .limit(1)
        .snapshots();
  }

  @override
  String toString() {
    return 'Membership{'
        'id: $id, dateOfStart: $dateOfStart, dateOfEnd: $dateOfEnd, '
        'numberOfVisits: $numberOfVisits, visitCounter: $visitCounter'
        '}';
  }
}
