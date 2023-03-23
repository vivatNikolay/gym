import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../../helpers/subscription_progress.dart';
import '../../../controllers/subscription_http_controller.dart';
import '../../../models/account.dart';
import '../../../models/subscription.dart';
import '../../../services/db/account_db_service.dart';
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
  final AccountDBService _accountDBService = AccountDBService();
  final SubscriptionHttpController _subscriptionHttpController =
      SubscriptionHttpController.instance;
  Future<List<Subscription>>? _futureSubscription;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _futureSubscription = _subscriptionHttpController.getByAccount();

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
            MembershipCard(
              subtitle: FutureBuilder<List<Subscription>>(
                future: _futureSubscription,
                builder: (context, snapshot) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => ScaffoldMessenger.of(context).clearSnackBars());
                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Нет интернет соединения'),
                        )));
                  }
                  if (snapshot.hasData) {
                    Account? s = _accountDBService.getFirst();
                    s?.subscriptions = snapshot.data!;
                    _accountDBService.put(s);
                  }
                  return Text(
                    SubscriptionProgress.getString(snapshot.data ??
                        _accountDBService.getFirst()!.subscriptions),
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
                    _futureSubscription =
                        _subscriptionHttpController.getByAccount();
                  });
                },
                icon: RotationTransition(
                    turns: _animationController,
                    child: const Icon(Icons.refresh, size: 32)),
              ),
              onTap: () {
                setState(() {
                  _futureSubscription =
                      _subscriptionHttpController.getByAccount();
                });
                if (_accountDBService.getFirst()!.subscriptions.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisitsList(
                            visits: _accountDBService
                                .getFirst()!
                                .subscriptions
                                .last
                                .visits,
                            title: 'История абонемента',
                          )));
                }
              },
            ),
            const SizedBox(height: 120),
            QrItem(
              data: _accountDBService.getFirst()!.email,
              onTap: () {
                ScreenBrightness().setScreenBrightness(1);
                showDialog(
                  context: context,
                  builder: (context) => QrDialog(
                    data: _accountDBService.getFirst()!.email,
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
