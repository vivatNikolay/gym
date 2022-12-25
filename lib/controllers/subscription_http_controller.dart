import '../models/account.dart';
import '../models/subscription.dart';
import '../services/db/account_db_service.dart';
import '../services/http/subscription_http_service.dart';

class SubscriptionHttpController {

  final SubscriptionHttpService _httpService = SubscriptionHttpService();
  final AccountDBService _dbService = AccountDBService();

  SubscriptionHttpController._privateConstructor();
  static final SubscriptionHttpController _instance = SubscriptionHttpController._privateConstructor();

  static SubscriptionHttpController get instance => _instance;

  Future<List<Subscription>> getByAccount() async {
    List<Subscription> subscriptions = await _httpService.getByAccount(_dbService.getFirst()!);
    Account? account = _dbService.getFirst();
    account!.subscriptions = subscriptions;
    _dbService.put(account);
    return subscriptions;
  }
}