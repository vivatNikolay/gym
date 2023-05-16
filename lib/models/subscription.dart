import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  String id;
  DateTime dateOfStart;
  DateTime dateOfEnd;
  int numberOfVisits;
  int visitCounter;

  Subscription({
    required this.id,
    required this.dateOfStart,
    required this.dateOfEnd,
    required this.numberOfVisits,
    required this.visitCounter,
  });

  factory Subscription.fromDocument(DocumentSnapshot doc) {
    return Subscription(
        id: doc.id,
        dateOfStart: doc.data().toString().contains('dateOfStart') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfStart')) : DateTime.now(),
        dateOfEnd: doc.data().toString().contains('dateOfEnd') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfEnd')) : DateTime.now(),
        numberOfVisits: doc.data().toString().contains('numberOfVisits') ? doc.get('numberOfVisits') : 0,
        visitCounter: doc.data().toString().contains('visitCounter') ? doc.get('visitCounter') : 0,
    );
  }

  static Future<void> addSubscription(String userId, int dateOfStart, int dateOfEnd, int numberOfVisits) async {
    await FirebaseFirestore.instance.collection('subscriptions').add({
      'userId': userId,
      'dateOfStart': dateOfStart,
      'dateOfEnd': dateOfEnd,
      'numberOfVisits': numberOfVisits,
      'visitCounter': 0,
    });
  }

  static Future<void> updateSubscription(String subscriptionId, int visitCounter) async {
    await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(subscriptionId)
        .update({
      'visitCounter': visitCounter,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSubscriptionStreamByUser(
      String userId) {
    return FirebaseFirestore.instance
        .collection('subscriptions')
        .where('userId',
        isEqualTo: userId)
        .orderBy('dateOfEnd')
        .limit(1)
        .snapshots();
  }

  @override
  String toString() {
    return 'Subscription{'
        'id: $id, dateOfStart: $dateOfStart, dateOfEnd: $dateOfEnd, '
        'numberOfVisits: $numberOfVisits, visitCounter: $visitCounter'
        '}';
  }
}
