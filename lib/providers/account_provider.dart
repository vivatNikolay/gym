import 'package:flutter/material.dart';

import '../services/account_db.dart';
import '../http/account_http_service.dart';
import '../models/account.dart';

class AccountPr extends ChangeNotifier {

  Account? _account;

  Account? get account {
    return _account;
  }

  AccountPr() {
    _account = AccountDB().getFirst();
  }

  Future<void> put(Account acc) async {
    await AccountHttpService().update(_account!, acc);
    await AccountDB().put(acc);
    _account = AccountDB().getFirst();
    notifyListeners();
  }

  Future<void> delete() async {
    await AccountDB().deleteAll();
    _account = null;
    notifyListeners();
  }

  Future<void> get(String email, String pass) async {
    _account = await AccountHttpService().login(email, pass);
    await AccountDB().put(_account);
    notifyListeners();
  }
}
