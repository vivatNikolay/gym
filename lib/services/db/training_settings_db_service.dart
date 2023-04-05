import 'package:hive/hive.dart';

import '../../models/training_settings.dart';

class TrainingSettingsDBService {

  final box = Hive.box<TrainingSettings>('training_settings');

  void put(TrainingSettings settings) {
    box.put(0, settings);
  }

  void deleteAll() {
    box.deleteAll(box.keys);
  }

  TrainingSettings getFirst() {
    return box.get(0) ?? TrainingSettings();
  }
}