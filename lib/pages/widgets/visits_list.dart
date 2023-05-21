import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/visit.dart';
import '../../services/visit_fire.dart';

class VisitsList extends StatefulWidget {
  final String title;
  final String accountId;
  final String? membershipId;

  const VisitsList(
      {required this.title,
      required this.accountId,
      this.membershipId,
      Key? key})
      : super(key: key);

  @override
  State<VisitsList> createState() => _VisitsListState();
}

class _VisitsListState extends State<VisitsList> {
  final DateFormat _formatterDate = DateFormat('dd.MM.yy');
  final DateFormat _formatterWeekDay = DateFormat('E');
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  final VisitFire _visitFire = VisitFire();

  @override
  void initState() {
    _stream = widget.membershipId != null
        ? _visitFire.streamByUserAndMembership(
            widget.accountId, widget.membershipId!)
        : _visitFire.streamByUser(widget.accountId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Посещения не загрузились'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Visit> visits = List.from(snapshot.data!.docs)
                .map((i) => Visit.fromDocument(i))
                .toList();
            if (visits.isNotEmpty) {
              return listView(visits);
            } else {
              return emptyMess();
            }
          }),
    );
  }

  ListView listView(List<Visit> visits) {
    return ListView.builder(
        itemCount: visits.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.75),
            child: ListTile(
              leading: Text(
                _formatterWeekDay.format(visits[index].date),
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              title: Text(_formatterDate.format(visits[index].date)),
            ),
          );
        });
  }

  Center emptyMess() {
    return const Center(
        child: Text(
      'Посещений нет',
      style: TextStyle(fontSize: 23.0),
    ));
  }
}
