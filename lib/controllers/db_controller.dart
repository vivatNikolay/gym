import '../models/sportsman.dart';
import '../services/db/sportsman_db_service.dart';

class DBController {

  final SportsmanDBService _sportsmanDBService = SportsmanDBService();

  DBController._privateConstructor();
  static final DBController _instance = DBController._privateConstructor();

  static DBController get instance => _instance;

  void addSportsman(Sportsman sportsman) {
    _sportsmanDBService.put(sportsman);
  }

  Sportsman? getSportsman() {
    return _sportsmanDBService.getFirst();
  }

  void deleteAll() {
    _sportsmanDBService.deleteAll();
  }

  bool isHasSportsman() {
    return _sportsmanDBService.getFirst() != null;
  }
}