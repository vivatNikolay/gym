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

  Future<bool> saveOrUpdate(Training training) async {
    if (training.isInBox) {
      await training.save();
    } else {
      await box.add(training);
    }
    return true;
  }
}