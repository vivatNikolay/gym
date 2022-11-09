import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sportsman.dart';
import '../../services/db/sportsman_db_service.dart';
import '../../services/http/subscription_http_service.dart';
import '../../helpers/constants.dart';
import '../../models/subscription.dart';
import 'history_of_sub.dart';
import 'widgets/qr_item.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> with SingleTickerProviderStateMixin {
  final SportsmanDBService _sportsmanDBService = SportsmanDBService();
  final SubscriptionHttpService _httpService = SubscriptionHttpService();
  Future<List<Subscription>>? _futureSubscription;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(gantelImage),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            opacity: 0.5,
          ),
        ),
        child: Column(children: [
            QrItem(data: _sportsmanDBService.getFirst()!.email),
            const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            color: Colors.white,
            child: ListTile(
                leading:
                    const Icon(Icons.credit_card, size: 26, color: mainColor),
                minLeadingWidth: 22,
                title: const Text(
                  'Membership',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                subtitle: FutureBuilder<List<Subscription>>(
                  future: _futureSubscription,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No connection'),
                        ));
                      });
                    }
                    if (snapshot.hasData) {
                      Sportsman? s = _sportsmanDBService.getFirst();
                      s?.subscriptions = snapshot.data!;
                      _sportsmanDBService.put(s);
                    }
                    return Text(
                      getProgress(snapshot.data ?? _sportsmanDBService.getFirst()!.subscriptions),
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                    );
                  },
                ),
                trailing: IconButton(
                  onPressed: () {
                    _animationController.forward(from: 0.0);
                    setState(() {
                      _futureSubscription = _httpService
                          .getBySportsman(_sportsmanDBService.getFirst()!.id);
                    });
                  },
                  icon: RotationTransition(
                      turns: _animationController,
                      child: const Icon(Icons.refresh,
                          size: 32, color: mainColor)),
                ),
                onTap: () {
                  setState(() {
                    _futureSubscription = _httpService
                        .getBySportsman(_sportsmanDBService.getFirst()!.id);
                  });
                  if (_sportsmanDBService.getFirst()!.subscriptions.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HistoryOfSub()));
                  }
                }),
          ),
        ]),
      ),
    );
  }

  String getProgress(List<Subscription> subscriptions) {
    Subscription? subscription;
    if (subscriptions.isNotEmpty) {
      subscription = subscriptions.last;
    }
    if (subscription != null) {
      if (subscription.dateOfEnd
          .isBefore(DateTime.now().add(const Duration(days: 1)))) {
        return 'has been expired in ${formatterDate.format(subscription.dateOfEnd)}';
      } else {
        return '${subscription.visitCounter}/${subscription.numberOfVisits} '
            'until ${formatterDate.format(subscription.dateOfEnd)}';
      }
    }
    return 'hasn\'t been added';
  }
}
