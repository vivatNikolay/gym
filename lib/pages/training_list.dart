import 'package:flutter/material.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training list'),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (_, index) {
            return Card(
              elevation: 4.0,
              child: ListTile(
                title: Text('$index'),
                subtitle: Text('$index'),
              ),
            );
          }),
    );
  }
}
