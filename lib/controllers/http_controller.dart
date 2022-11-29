import 'package:sportmen_in_gym/services/http/visit_http_service.dart';

import '../models/sportsman.dart';
import '../models/visit.dart';
import '../services/http/sportsman_http_service.dart';

class HttpController {

  final SportsmanHttpService _sportsmanHttpService = SportsmanHttpService();
  final VisitHttpService _visitHttpService = VisitHttpService();

  HttpController._privateConstructor();
  static final HttpController _instance = HttpController._privateConstructor();

  static HttpController get instance => _instance;

  Future<Sportsman> getSportsman(String email, String pass) async {
    Sportsman sportsman = await _sportsmanHttpService.getByEmail(email, pass);
    if (pass == sportsman.password) {
      return sportsman;
    } else {
      throw "Incorrect password";
    }
  }

  Future<bool> putSportsman(Sportsman sportsman) async {
    bool success = await _sportsmanHttpService.putByEmail(sportsman);
    return success;
  }

  Future<List<Visit>> getVisitsByDates(Sportsman sportsman) async {
    List<Visit> visits = await _visitHttpService.getBySubscription(sportsman);
    return visits;
  }
}