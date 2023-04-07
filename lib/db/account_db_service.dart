import 'package:hive/hive.dart';

import '../../models/account.dart';

class AccountDBService {

  final box = Hive.box<Account>('account');

  void put(Account? account) {
    if (account != null) {
      box.put(0, account);
    }
  }

  void deleteAll() {
    box.deleteAll(box.keys);
  }

  Account? getFirst() {
    return box.get(0);
  }
}