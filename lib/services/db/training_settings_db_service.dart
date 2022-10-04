import 'package:hive/hive.dart';

import '../../models/training_settings.dart';
import 'db_service.dart';

class TrainingSettingsDBService extends DBService<TrainingSettings> {

  final box = Hive.box<TrainingSettings>('training_settings');

  @override
  void put(TrainingSettings settings) {
    box.put(0, settings);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  TrainingSettings getFirst() {
    return box.get(0) ?? TrainingSettings();
  }
}