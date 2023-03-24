import 'package:flutter/material.dart';

import '../../../../helpers/constants.dart';

class MembershipCard extends StatelessWidget {
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const MembershipCard(
      {required this.subtitle,
      required this.trailing,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              child: const Icon(Icons.credit_card, size: 40, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: ListTile(
                title: const Text(
                  'Абонемент',
                  style: TextStyle(fontSize: 23),
                ),
                subtitle: subtitle,
                trailing: trailing,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
