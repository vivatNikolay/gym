import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../providers/account_provider.dart';
import '../profile_edit/profile_edit.dart';

class ProfileBox extends StatelessWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountPr>(context).account!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: mainColor,
              radius: 50.0,
              child: Image.asset('images/profileImg${account.iconNum}.png'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileEdit()));
              },
              child: const Icon(
                Icons.edit,
                color: mainColor,
                size: 28,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${account.firstName ?? ''} ${account.lastName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          account.email ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
