class Visit {
  int id;
  DateTime date;

  Visit({
    required this.id,
    required this.date
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
        id: json["id"],
        date: DateTime.parse(json["date"].toString()),
    );
  }

  @override
  String toString() {
    return 'Visit{'
        'id: $id, date: $date'
        '}';
  }
}
