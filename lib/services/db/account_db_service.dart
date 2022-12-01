import 'package:hive/hive.dart';

import '../../models/account.dart';
import 'db_service.dart';

class AccountDBService extends DBService<Account> {

  final box = Hive.box<Account>('account');

  @override
  void put(Account? account) {
    if (account != null) {
      box.put(0, account);
    }
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  Account? getFirst() {
    return box.get(0);
  }
}