import '../../services/http/visit_http_service.dart';
import '../models/account.dart';
import '../models/visit.dart';
import '../services/db/account_db_service.dart';
import '../services/http/account_http_service.dart';

class AccountHttpController {

  final AccountDBService _accountDBService = AccountDBService();
  final AccountHttpService _httpService = AccountHttpService();

  AccountHttpController._privateConstructor();
  static final AccountHttpController _instance = AccountHttpController._privateConstructor();

  static AccountHttpController get instance => _instance;

  Future<Account> getAccount(String email, String pass) async {
    Account account = await _httpService.login(email, pass);
    if (pass == account.password) {
      return account;
    } else {
      throw "Incorrect password";
    }
  }

  Future<bool> putAccount(Account account) async {
    return await _httpService.update(account);
  }

  Future<List<Account>> getSportsmenByQuery(String query) async {
    return await _httpService.getSportsmenByQuery(_accountDBService.getFirst()!, query);
  }

  Future<Account> getSportsmenByEmail(String email) async {
    return await _httpService.getSportsmenByEmail(_accountDBService.getFirst()!, email);
  }
}