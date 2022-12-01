import 'package:sportmen_in_gym/services/http/visit_http_service.dart';

import '../models/account.dart';
import '../models/visit.dart';
import '../services/http/account_http_service.dart';

class HttpController {

  final AccountHttpService _accountHttpService = AccountHttpService();
  final VisitHttpService _visitHttpService = VisitHttpService();

  HttpController._privateConstructor();
  static final HttpController _instance = HttpController._privateConstructor();

  static HttpController get instance => _instance;

  Future<Account> getAccount(String email, String pass) async {
    Account account = await _accountHttpService.login(email, pass);
    if (pass == account.password) {
      return account;
    } else {
      throw "Incorrect password";
    }
  }

  Future<bool> putAccount(Account account) async {
    bool success = await _accountHttpService.update(account);
    return success;
  }

  Future<List<Visit>> getVisitsByDates(Account account) async {
    List<Visit> visits = await _visitHttpService.getBySubscription(account);
    return visits;
  }
}