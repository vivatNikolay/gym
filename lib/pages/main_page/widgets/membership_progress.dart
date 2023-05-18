import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/membership.dart';

class MembershipProgress extends StatelessWidget {
  final DateFormat _formatterDate = DateFormat('dd.MM.yy');
  final Membership? membership;
  final double? fontSize;

  MembershipProgress({required this.membership, this.fontSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getString(context, membership),
      style: TextStyle(
        fontSize: fontSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  _getString(BuildContext context, Membership? membership) {
    if (membership == null) {
      return 'Отсутствует';
    }
    return '${membership.visitCounter}/${membership.numberOfVisits}\n'
        'c ${_formatterDate.format(membership.dateOfStart)} '
        'по ${_formatterDate.format(membership.dateOfEnd)}';
  }
}
