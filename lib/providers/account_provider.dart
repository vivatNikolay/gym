import 'package:flutter/material.dart';

import '../models/account.dart';
import '../services/account_fire.dart';

class AccountPr extends ChangeNotifier {

  final AccountFire _accountFire = AccountFire();
  Account? _account;

  Account? get account {
    return _account;
  }

  AccountPr();

  Future<void> login(String email, String pass) async {
    await _accountFire.login(email, pass);
    notifyListeners();
  }

  Future<Account?> init() async {
    _account = await _accountFire.init();
    notifyListeners();
    return _account;
  }

  Future<void> put(Account acc) async {
    await _accountFire.put(acc);
    _account = acc;
    notifyListeners();
  }

  Future<void> logout() async {
    await _accountFire.logout();
    _account = null;
    notifyListeners();
  }

  Future<void> updatePass(String newPass) async {
    await _accountFire.updatePass(newPass);
  }
}
