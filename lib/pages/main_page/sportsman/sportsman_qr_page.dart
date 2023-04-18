import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../../helpers/subscription_progress.dart';
import '../../../providers/account_provider.dart';
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
  Future<void>? _future;
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
    final account = Provider.of<AccountPr>(context).account!;
    return MainScaffold(
      title: 'QR-код',
      body: SingleChildScrollView(
        child: Column(
          children: [
            MembershipCard(
              subtitle: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => ScaffoldMessenger.of(context).clearSnackBars());
                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(snapshot.error!.toString()),
                        )));
                  }
                  return Text(
                    SubscriptionProgress.getString(account.subscriptions),
                    style: const TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),
              trailing: IconButton(
                onPressed: () {
                  _animationController.forward(from: 0.0);
                  setState(() {
                    _future = Provider.of<AccountPr>(context, listen: false).get(account.email, account.password);
                  });
                },
                icon: RotationTransition(
                    turns: _animationController,
                    child: const Icon(Icons.refresh, size: 32)),
              ),
              onTap: () {
                setState(() {
                  _future = Provider.of<AccountPr>(context, listen: false).get(account.email, account.password);
                });
                if (account.subscriptions.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisitsList(
                            visits: account
                                .subscriptions
                                .last
                                .visits,
                            title: 'История абонемента',
                          )));
                }
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            QrItem(
              data: account.email,
              onTap: () {
                ScreenBrightness().setScreenBrightness(1);
                showDialog(
                  context: context,
                  builder: (context) => QrDialog(
                    data: account.email,
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
