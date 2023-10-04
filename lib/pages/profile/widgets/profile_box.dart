import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../models/account.dart';
import '../../../providers/account_provider.dart';
import '../profile_edit/profile_edit.dart';

class ProfileBox extends StatelessWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<AccountPr>(context, listen: true).account!;
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
                await Navigator.of(context).pushNamed(ProfileEdit.routeName);
              },
              child: const Icon(
                Icons.edit,
                color: mainColor,
                size: 28,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        _textWithTooltip('${account.firstName} ${account.lastName}', 24),
        _textWithTooltip(account.email, 18),
      ],
    );
  }

  Widget _textWithTooltip(String text, double? fontSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Tooltip(
        message: text,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
