import 'package:cloud_firestore/cloud_firestore.dart';

class Visit {
  String? id;
  DateTime date;
  String userId;
  String? membershipId;

  Visit({
    this.id,
    required this.date,
    required this.userId,
    this.membershipId,
  });

  factory Visit.fromDocument(DocumentSnapshot doc) {
    return Visit(
      id: doc.id,
      date: doc.data().toString().contains('date') ? DateTime.fromMillisecondsSinceEpoch(doc.get('date')) : DateTime.now(),
      userId: doc.data().toString().contains('userId') ? doc.get('userId') : '',
      membershipId: doc.data().toString().contains('membershipId') ? doc.get('membershipId') : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'date': date.millisecondsSinceEpoch,
    'userId': userId,
    'membershipId': membershipId,
  };

  @override
  String toString() {
    return 'Visit{id: $id, date: $date, userId: $userId,'
        ' membershipId: $membershipId}';
  }
}
