import 'package:hive/hive.dart';

import '../../models/account.dart';

class AccountDBService {

  final box = Hive.box<Account>('account');

  Future<void> put(Account? account) async {
    if (account != null) {
      await box.put(0, account);
    }
  }

  Future<void> deleteAll() async {
    await box.deleteAll(box.keys);
  }

  Account? getFirst() {
    return box.get(0);
  }
}