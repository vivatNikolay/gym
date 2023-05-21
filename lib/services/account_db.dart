import 'package:hive/hive.dart';

import '../../models/account.dart';
import 'hive_db.dart';

class AccountDB extends HiveDB<Account> {

  final box = Hive.box<Account>('account');

  @override
  Future<void> put(Account? account) async {
    if (account != null) {
      await box.put(0, account);
    }
  }

  @override
  Future<void> deleteAll() async {
    await box.deleteAll(box.keys);
  }

  @override
  Account? getFirst() {
    return box.get(0);
  }
}