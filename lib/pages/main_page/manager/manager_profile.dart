import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controllers/visit_http_controller.dart';
import '../../../controllers/account_http_controller.dart';
import '../../../models/subscription.dart';
import '../../../models/account.dart';
import '../../../helpers/constants.dart';
import 'manager_profile_edit.dart';
import 'widgets/add_membership.dart';

class ManagerProfile extends StatefulWidget {
  final String email;

  ManagerProfile({required this.email, Key? key}) : super(key: key);

  @override
  State<ManagerProfile> createState() => _ManagerProfileState(email);
}

class _ManagerProfileState extends State<ManagerProfile> {
  final String email;
  final AccountHttpController _accountHttpController =
      AccountHttpController.instance;
  final VisitHttpController _visitHttpController = VisitHttpController.instance;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  late Future<Account> _futureAccount;

  _ManagerProfileState(this.email);

  @override
  void initState() {
    super.initState();
    _futureAccount = _accountHttpController.getSportsmenByEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sportsman'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<Account>(
              future: _futureAccount,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                          color: mainColor, strokeWidth: 5),
                    );
                  default:
                    if (snapshot.hasError) {
                      return noConnectionMess();
                    }
                    return Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      height: 210,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  radius: 50.0,
                                  child: Image.asset(
                                      'images/profileImg${snapshot.data!.iconNum}.png'),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Tooltip(
                                      message: snapshot.data!.firstName,
                                      child: Text(snapshot.data!.firstName,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Tooltip(
                                      message: snapshot.data!.email,
                                      child: Text(snapshot.data!.email,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 19)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size.fromWidth(140),
                                  backgroundColor: mainColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ManagerProfileEdit(
                                          account: snapshot.data!)));
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit profile"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size.fromWidth(140),
                                  backgroundColor: mainColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await _visitHttpController.addVisitToSportsman(snapshot.data!)
                                      .then((value) => value ? ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Visit added'),
                                  )) : null);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Add visit"),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size.fromWidth(300),
                              backgroundColor: mainColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: isMembershipInactive(
                                    snapshot.data!.subscriptions)
                                ? () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AddMembership(snapshot.data!.email)));
                            }
                                : null,
                            icon: const Icon(Icons.add_card),
                            label: const Text("Add new membership"),
                          ),
                        ],
                      ),
                    );
                }
              }),
        ),
      ),
    );
  }

  Center noConnectionMess() {
    return const Center(
        child: Text(
      'No connection or not found',
      style: TextStyle(fontSize: 23.0),
    ));
  }

  bool isMembershipInactive(List<Subscription> subscriptions) {
    if (subscriptions.isEmpty) {
      return true;
    }
    Subscription subscription = subscriptions.last;
    if (subscription.dateOfEnd.isBefore(DateTime.now()) ||
        subscription.visits.length >= subscription.numberOfVisits) {
      return true;
    }
    return false;
  }
}
