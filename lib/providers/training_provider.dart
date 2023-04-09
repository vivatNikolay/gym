import 'dart:collection';

import 'package:flutter/material.dart';

import '../db/training_db_service.dart';
import '../models/training.dart';

class TrainingPr extends ChangeNotifier {
  List<Training> _trainings = TrainingDBService().getAll();

  UnmodifiableListView<Training> get trainings {
    return UnmodifiableListView(_trainings);
  }

  void put(Training training) async {
    await TrainingDBService().saveOrUpdate(training);
    _trainings = TrainingDBService().getAll();
    notifyListeners();
  }

  void delete(Training training) async {
    await TrainingDBService().delete(training);
    _trainings = TrainingDBService().getAll();
    notifyListeners();
  }

  Training findByKey(int key) {
    return _trainings.firstWhere((tr) => tr.key == key);
  }
}
