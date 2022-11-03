import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sportsman.dart';
import '../../services/http/subscription_http_service.dart';
import '../../helpers/constants.dart';
import '../../models/subscription.dart';
import '../../controllers/db_controller.dart';
import 'history_of_sub.dart';
import 'widgets/qr_item.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> with SingleTickerProviderStateMixin {
  final DBController _dbController = DBController.instance;
  final SubscriptionHttpService _httpService = SubscriptionHttpService();
  Future<Subscription?>? _futureSubscription;
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(gantelImage),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            opacity: 0.5,
          ),
        ),
        child: ListView(padding: const EdgeInsets.only(top: 30), children: [
            QrItem(data: _dbController.getSportsman()!.email),
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
                subtitle: FutureBuilder<Subscription?>(
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
                    Sportsman? s = _dbController.getSportsman();
                    s?.subscription = snapshot.data;
                    _dbController.saveOrUpdateSportsman(s);
                    return Text(
                      getProgress(snapshot.data),
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                    );
                  },
                ),
                trailing: IconButton(
                  onPressed: () {
                    _animationController.forward(from: 0.0);
                    setState(() {
                      _futureSubscription = _httpService
                          .getBySportsman(_dbController.getSportsman()!.id);
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
                        .getBySportsman(_dbController.getSportsman()!.id);
                  });
                  if (_dbController.getSportsman()!.subscription != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HistoryOfSub()));
                  }
                }),
          ),
        ]),
      ),
    );
  }

  String getProgress(Subscription? subscription) {
    subscription ??= _dbController.getSportsman()!.subscription;
    if (subscription != null) {
      return '${subscription.visitCounter}/${subscription.numberOfVisits} '
          'until ${formatterDate.format(subscription.dateOfEnd)}';
    } else {
      return '(no)';
    }
  }
}
