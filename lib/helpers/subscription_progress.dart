import 'package:intl/intl.dart';

import '../models/subscription.dart';

class SubscriptionProgress {
  static final DateFormat _formatterDate = DateFormat('dd.MM.yy');

  static getString(List<Subscription> subscriptions) {
    Subscription? subscription;
    if (subscriptions.isNotEmpty) {
      subscription = subscriptions.last;
    }
    if (subscription != null) {
      return '${subscription.visits.length}/${subscription.numberOfVisits}\n'
          'c ${_formatterDate.format(subscription.dateOfStart)} по ${_formatterDate.format(subscription.dateOfEnd)}';
    }
    return 'Отсутствует';
  }
}
