import 'package:hive/hive.dart';
import '../../models/training.dart';

class TrainingDBService {

  final box = Hive.box<Training>('training');

  Future<void> delete(Training training) async {
    await box.delete(training.key);
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