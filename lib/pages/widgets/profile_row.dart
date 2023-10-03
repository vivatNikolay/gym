import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../helpers/constants.dart';

class ProfileRow extends StatelessWidget {
  final Account account;
  final VoidCallback onEdit;
  const ProfileRow({required this.account, required this.onEdit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: CircleAvatar(
            backgroundColor:
            Theme.of(context).colorScheme.background,
            radius: 50.0,
            child: Image.asset(
                'images/profileImg${account.iconNum}.png'),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: account.firstName,
                  child: Text('${account.firstName} ${account.lastName}',
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold)),
                ),
                Tooltip(
                  message: account.email,
                  child: Text(account.email,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onEdit,
            child: const Icon(Icons.edit, color: mainColor, size: 28),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ],
    );
  }
}
