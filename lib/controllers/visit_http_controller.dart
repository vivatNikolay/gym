import '../../services/http/visit_http_service.dart';
import '../models/account.dart';
import '../models/visit.dart';
import '../services/db/account_db_service.dart';
import '../services/http/account_http_service.dart';

class VisitHttpController {

  final VisitHttpService _httpService = VisitHttpService();
  final AccountDBService _accountDBService = AccountDBService();

  VisitHttpController._privateConstructor();
  static final VisitHttpController _instance = VisitHttpController._privateConstructor();

  static VisitHttpController get instance => _instance;

  Future<List<Visit>> getOwnVisitsBySubscription() async {
    List<Visit> visits = await _httpService.getBySubscription(_accountDBService.getFirst()!);
    return visits;
  }

  Future<bool> addSingleVisit(Account account) async {
    bool success = await _httpService.addSingleVisit(account, _accountDBService.getFirst()!);
    return success;
  }

  Future<bool> addVisitToMembership(Account account) async {
    bool success = await _httpService.addVisitToMembership(account, _accountDBService.getFirst()!);
    return success;
  }
}