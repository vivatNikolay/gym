import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/subscription.dart';

class SubscriptionProgress extends StatelessWidget {
  final DateFormat _formatterDate = DateFormat('dd.MM.yy');
  final Subscription? subscription;
  final double? fontSize;

  SubscriptionProgress({required this.subscription, this.fontSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getString(context, subscription),
      style: TextStyle(
        fontSize: fontSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  _getString(BuildContext context, Subscription? subscription) {
    if (subscription == null) {
      return 'Отсутствует';
    }
    return '${subscription.visitCounter}/${subscription.numberOfVisits}\n'
        'c ${_formatterDate.format(subscription.dateOfStart)} '
        'по ${_formatterDate.format(subscription.dateOfEnd)}';
  }
}
