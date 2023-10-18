import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../services/account_fire.dart';
import '../../../services/membership_fire.dart';
import '../widgets/membership_progress.dart';
import '../../../models/membership.dart';
import '../../visits_list.dart';
import '../../widgets/main_scaffold.dart';
import '../widgets/qr_item.dart';
import 'widgets/membership_card.dart';
import 'widgets/qr_dialog.dart';

final String _accountId = AccountFire().currentUserId();
final MembershipFire _membershipFire = MembershipFire();

class SportsmanQrPage extends StatelessWidget {
  final Widget? bottomNavBar;
  const SportsmanQrPage({this.bottomNavBar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      bottomNavBar: bottomNavBar,
      title: 'qrCode'.i18n(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: _membershipFire.streamByUser(_accountId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                Membership? membership;
                if (!snapshot.hasError && snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  membership =
                      Membership.fromDocument(snapshot.data!.docs.first);
                }
                return MembershipCard(
                  subtitle: MembershipProgress(
                    membership: membership,
                    fontSize: 17,
                  ),
                  onTap: () {
                    if (membership != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VisitsList(
                                accountId: _accountId,
                                membershipId: membership!.id,
                                title: 'membershipHistory'.i18n(),
                              )));
                    }
                  },
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            QrItem(
              data: _accountId,
              onTap: () {
                ScreenBrightness().setScreenBrightness(1);
                showDialog(
                  context: context,
                  builder: (context) => QrDialog(
                    data: _accountId,
                  ),
                ).then((value) => ScreenBrightness().resetScreenBrightness());
              },
            ),
          ],
        ),
      ),
    );
  }
}
