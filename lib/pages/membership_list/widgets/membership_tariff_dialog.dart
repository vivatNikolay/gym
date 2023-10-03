import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:sportmen_in_gym/models/membership_tariff.dart';

import '../../../helpers/constants.dart';

class MembershipTariffDialog extends StatelessWidget {
  final MembershipTariff? tariff;

  const MembershipTariffDialog(this.tariff, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tariff == null) {
      return AlertDialog(
        title: Text('membershipError'.i18n()),
      );
    }
    return AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Text(tariff!.name),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Длительность: ${tariff!.duration}'),
            Text('Кол-во посещений: ${tariff!.numberOfVisits}'),
            Text('Цена: ${tariff!.price}'),
            Text(tariff!.description ?? ''),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'close'.i18n(),
            style: const TextStyle(color: mainColor, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
