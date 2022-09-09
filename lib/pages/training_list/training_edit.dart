import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/models/exercise.dart';

import '../../models/training.dart';
import '../../services/db/training_db_service.dart';

class TrainingEdit extends StatefulWidget {
  final Training training;

  const TrainingEdit({required this.training, Key? key}) : super(key: key);

  @override
  State<TrainingEdit> createState() => _TrainingEditState(training);
}

class _TrainingEditState extends State<TrainingEdit> {
  final Training training;
  final TrainingDBService dbService = TrainingDBService();
  late List<Exercise> _exercises;
  late TextEditingController exerciseController;

  _TrainingEditState(this.training);

  @override
  void initState() {
    _exercises = training.exercises;

    exerciseController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(training.name),
        actions: [
          IconButton(
              onPressed: () {
                dbService.delete(training);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outlined)),
          IconButton(
              onPressed: () {
                dbService.saveOrUpdate(training);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
        child: Column(
          children: [
            InkWell(
              child: Card(
                color: Theme.of(context).primaryColor.withOpacity(0.75),
                elevation: 2.0,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text('Add exercise', style: TextStyle(fontSize: 19)),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () {
                openDialog(Exercise(name: '', reps: 10, sets: 5));
              },
            ),
          ],
        ),
      )),
    );
  }

  Widget buildList(BuildContext context) {
    if (_exercises.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _exercises.length,
          itemBuilder: (_, index) {
            return Card(
              color: Theme.of(context).primaryColor.withOpacity(0.75),
              elevation: 4.0,
              child: ListTile(
                title: Text('${_exercises[index].name}',
                    style: const TextStyle(fontSize: 19)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {},
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          });
    } else {
      return Container();
    }
  }

  Future openDialog(Exercise exercise) {
    exerciseController.text = exercise.name;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Exercise'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Container(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                      controller: exerciseController,
                    ),
                    Slider(
                      min: 1,
                      max: 100,
                      divisions: 100,
                      value: exercise.reps.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          exercise.reps = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {},
                )
              ],
            ));
  }
}
