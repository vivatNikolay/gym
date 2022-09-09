import 'package:hive/hive.dart';
import '../../models/training.dart';

class TrainingDBService {

  final box = Hive.box<Training>('training');

  void delete(Training training) {
    box.delete(training.key);
  }

  void deleteAll() {
    box.deleteAll(box.keys);
  }

  List<Training> getAll() {
    return box.values.toList();
  }

  void saveOrUpdate(Training training) {
    if (training.isInBox) {
      training.save();
    } else {
      box.add(training);
    }
  }
}