import 'package:flutter/material.dart';

import '../db/account_db_service.dart';
import '../http/account_http_service.dart';
import '../models/account.dart';

class AccountPr extends ChangeNotifier {

  Account? _account;

  Account? get account {
    return _account;
  }

  AccountPr() {
    _account = AccountDBService().getFirst();
  }

  Future<void> put(Account acc) async {
    await AccountHttpService().update(_account!, acc);
    await AccountDBService().put(acc);
    _account = AccountDBService().getFirst();
    notifyListeners();
  }

  Future<void> delete() async {
    await AccountDBService().deleteAll();
    _account = null;
    notifyListeners();
  }

  Future<void> get(String email, String pass) async {
    _account = await AccountHttpService().login(email, pass);
    await AccountDBService().put(_account);
    notifyListeners();
  }
}
