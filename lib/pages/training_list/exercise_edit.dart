import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../services/exercise_fire.dart';
import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../../models/user_settings.dart';
import '../../providers/user_settings_provider.dart';
import '../widgets/my_text_form_field.dart';

class ExerciseEdit extends StatefulWidget {
  final Exercise? exercise;
  final String trainingId;

  const ExerciseEdit({required this.trainingId, this.exercise, Key? key}) : super(key: key);

  @override
  State<ExerciseEdit> createState() => _ExerciseEditState();
}

class _ExerciseEditState extends State<ExerciseEdit> {
  final ExerciseFire _exerciseFire = ExerciseFire();
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  Exercise? exercise;
  String _name = '';
  late int _sets;
  late int _reps;
  double? _weight;
  double? _duration;

  @override
  void initState() {
    super.initState();
    exercise = widget.exercise;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final UserSettings settings =
          Provider.of<UserSettingsPr>(context, listen: false).settings!;

      _sets = settings.defaultExerciseSets;
      _reps = settings.defaultExerciseReps;

      if (exercise != null) {
        _name = exercise!.name;
        _sets = exercise!.sets;
        _reps = exercise!.reps;
        _weight = exercise!.weight;
        _duration = exercise!.duration;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _save() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (exercise != null) {
        exercise!
          ..trainingId = widget.trainingId
          ..name = _name
          ..reps = _reps
          ..sets = _sets
          ..weight = _weight
          ..duration = _duration;
        _exerciseFire.put(exercise!);
      } else {
        _exerciseFire.create(Exercise(
            name: _name,
            reps: _reps,
            sets: _sets,
            weight: _weight,
            duration: _duration,
            creationDate: DateTime.now(),
            trainingId: widget.trainingId));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('exercise'.i18n()),
        actions: [
          IconButton(
            onPressed: _save,
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextFormField(
                  fieldName: 'title'.i18n(),
                  initialValue: _name,
                  autofocus: _name.isEmpty,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return 'emptyField'.i18n();
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _name = value.trim();
                    }
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  '${'numberOfSets'.i18n()}:',
                  style: const TextStyle(fontSize: 15),
                ),
                SfSlider(
                  min: 0,
                  max: 10,
                  interval: 5,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _sets.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _sets = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  '${'numberOfReps'.i18n()}:',
                  style: const TextStyle(fontSize: 15),
                ),
                SfSlider(
                  min: 0,
                  max: 30,
                  interval: 10,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _reps.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _reps = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
                Text(
                  '${'weight'.i18n()}:',
                  style: const TextStyle(fontSize: 15),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: MyTextFormField(
                    initialValue: _weight != null ? _weight.toString() : '',
                    validator: (value) {
                      if (value != null && value != '') {
                        if (double.tryParse(value) == null) {
                          return 'enterNumber'.i18n();
                        }
                        if (double.parse(value) <= 0) {
                          return 'numberShouldBeAboveZero'.i18n();
                        }
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value != '') {
                        _weight = double.parse(value);
                      }
                    },
                    maxLength: 8,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${'duration'.i18n()}:',
                  style: const TextStyle(fontSize: 15),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: MyTextFormField(
                    initialValue: _duration != null ? _duration.toString() : '',
                    validator: (value) {
                      if (value != null && value != '') {
                        if (double.tryParse(value) == null) {
                          return 'enterNumber'.i18n();
                        }
                        if (double.parse(value) <= 0) {
                          return 'numberShouldBeAboveZero'.i18n();
                        }
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value != '') {
                        _duration = double.parse(value);
                      }
                    },
                    maxLength: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
