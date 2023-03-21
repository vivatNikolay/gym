import 'package:flutter/material.dart';

import '../../../../helpers/subscription_progress.dart';
import '../../../controllers/subscription_http_controller.dart';
import '../../../helpers/constants.dart';
import '../../../models/account.dart';
import '../../../models/subscription.dart';
import '../../../services/db/account_db_service.dart';
import '../../profile/profile.dart';
import '../../widgets/visits_list.dart';
import 'widgets/qr_item.dart';

class SportsmanQrPage extends StatefulWidget {
  const SportsmanQrPage({Key? key}) : super(key: key);

  @override
  State<SportsmanQrPage> createState() => _SportsmanQrPageState();
}

class _SportsmanQrPageState extends State<SportsmanQrPage> with SingleTickerProviderStateMixin {
  final AccountDBService _accountDBService = AccountDBService();
  final SubscriptionHttpController _subscriptionHttpController = SubscriptionHttpController.instance;
  Future<List<Subscription>>? _futureSubscription;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _futureSubscription = _subscriptionHttpController
        .getByAccount();

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('QR-код'),
      ),
      drawer: const Profile(),
      body: Column(children: [
        const SizedBox(height: 20),
        QrItem(data: _accountDBService.getFirst()!.email),
        const SizedBox(height: 20),
        Card(
          color: Colors.white,
          child: ListTile(
              leading:
              const Icon(Icons.credit_card, size: 26, color: mainColor),
              minLeadingWidth: 22,
              title: const Text(
                'Абонемент',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              subtitle: FutureBuilder<List<Subscription>>(
                future: _futureSubscription,
                builder: (context, snapshot) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      ScaffoldMessenger.of(context).clearSnackBars()
                  );
                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Нет интернет соединения'),
                        ))
                    );
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
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  );
                },
              ),
              trailing: IconButton(
                onPressed: () {
                  _animationController.forward(from: 0.0);
                  setState(() {
                    _futureSubscription = _subscriptionHttpController
                        .getByAccount();
                  });
                },
                icon: RotationTransition(
                    turns: _animationController,
                    child: const Icon(Icons.refresh,
                        size: 32, color: mainColor)),
              ),
              onTap: () {
                setState(() {
                  _futureSubscription =
                      _subscriptionHttpController.getByAccount();
                });
                if (_accountDBService.getFirst()!.subscriptions.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisitsList(
                            visits: _accountDBService.getFirst()!
                                .subscriptions.last.visits,
                            title: 'История абонемента',
                          )));
                }
              }),
        ),
      ]),
    );
  }
}
