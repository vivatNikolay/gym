import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../widgets/my_text_field.dart';

class ExerciseEdit extends StatefulWidget {
  final ValueNotifier<Exercise> exercise;

  const ExerciseEdit({required this.exercise, Key? key}) : super(key: key);

  @override
  State<ExerciseEdit> createState() => _ExerciseEditState(exercise);
}

class _ExerciseEditState extends State<ExerciseEdit> {
  final ValueNotifier<Exercise> exercise;
  final TextEditingController _exerciseController = TextEditingController();
  late ValueNotifier<bool> _exerciseValidation;

  _ExerciseEditState(this.exercise);

  @override
  void initState() {
    super.initState();

    _exerciseController.text = exercise.value.name;
    _exerciseValidation = ValueNotifier(true);
    _exerciseController.addListener(_controllerListener);
  }

  void _controllerListener() {
    _exerciseValidation.value = _exerciseController.text.isNotEmpty;
    if (_exerciseValidation.value) {
      setState(() {
        exercise.value.name = _exerciseController.text;
      });
    }
  }

  @override
  void dispose() {
    _exerciseController.removeListener(_controllerListener);
    _exerciseValidation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() => _exerciseValidation.value = _exerciseController.text.isNotEmpty);
        return Future.value(_exerciseValidation.value);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Name:', style: TextStyle(fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MyTextField(
                  autofocus: _exerciseController.text.isEmpty,
                  controller: _exerciseController,
                  validation: _exerciseValidation,
                ),
              ),
              const SizedBox(height: 15),
              const Text('Sets count:', style: TextStyle(fontSize: 15)),
              SfSlider(
                min: 0,
                max: 10,
                interval: 5,
                showLabels: true,
                enableTooltip: true,
                activeColor: mainColor,
                value: exercise.value.sets.toDouble(),
                onChanged: (value) {
                  setState(() {
                    exercise.value.sets = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text('Reps count:', style: TextStyle(fontSize: 15)),
              SfSlider(
                min: 0,
                max: 30,
                interval: 10,
                showLabels: true,
                enableTooltip: true,
                activeColor: mainColor,
                value: exercise.value.reps.toDouble(),
                onChanged: (value) {
                  setState(() {
                    exercise.value.reps = value.toInt();
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
