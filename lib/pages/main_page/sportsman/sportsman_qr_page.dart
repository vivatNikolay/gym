import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../services/account_fire.dart';
import '../../../services/membership_fire.dart';
import '../widgets/membership_progress.dart';
import '../../../models/membership.dart';
import '../../widgets/visits_list.dart';
import '../../widgets/main_scaffold.dart';
import '../widgets/qr_item.dart';
import 'widgets/membership_card.dart';
import 'widgets/qr_dialog.dart';

class SportsmanQrPage extends StatefulWidget {
  const SportsmanQrPage({Key? key}) : super(key: key);

  @override
  State<SportsmanQrPage> createState() => _SportsmanQrPageState();
}

class _SportsmanQrPageState extends State<SportsmanQrPage>
    with SingleTickerProviderStateMixin {
  final String _accountId = AccountFire().currentUserId();
  final MembershipFire _membershipFire = MembershipFire();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'QR-код',
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
                                title: 'История абонемента',
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
