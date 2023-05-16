import 'package:cloud_firestore/cloud_firestore.dart';

class Visit {
  String id;
  DateTime date;

  Visit({
    required this.id,
    required this.date
  });

  factory Visit.fromDocument(DocumentSnapshot doc) {
    return Visit(
      id: doc.id,
      date: doc.data().toString().contains('date') ? doc.get('date').toDate() : DateTime.now(),
    );
  }

  static Future<void> addVisit(String userId, String? subscriptionId) async {
    await FirebaseFirestore.instance.collection('visits').add({
      'date': Timestamp.now(),
      'userId': userId,
      'subscriptionId': subscriptionId,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getVisitStreamByUser(
      String userId) {
    return FirebaseFirestore.instance
        .collection('visits')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getVisitStreamByUserAndSub(
      String userId, String subscriptionId) {
    return FirebaseFirestore.instance
        .collection('visits')
        .where('userId', isEqualTo: userId)
        .where('subscriptionId', isEqualTo: subscriptionId)
        .orderBy('date')
        .snapshots();
  }

  @override
  String toString() {
    return 'Visit{id: $id, date: $date}';
  }
}
