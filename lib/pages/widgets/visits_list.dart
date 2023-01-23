import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/visit.dart';

class VisitsList extends StatelessWidget {
  final DateFormat _formatterDate = DateFormat('dd.MM.yyyy');
  final DateFormat _formatterWeekDay = DateFormat('E');
  final List<Visit> visits;
  final String title;

  VisitsList({required this.title, required this.visits, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (visits.isNotEmpty) {
      return listView(visits);
    } else {
      return emptyMess();
    }
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
      'History is empty',
      style: TextStyle(fontSize: 23.0),
    ));
  }
}
