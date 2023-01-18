import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controllers/visit_http_controller.dart';
import '../../../controllers/account_http_controller.dart';
import '../../../models/subscription.dart';
import '../../../models/account.dart';
import '../../../helpers/constants.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/profile_row.dart';
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
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
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: [
                            ProfileRow(
                              account: snapshot.data!,
                              onEdit: () async {
                                await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ManagerProfileEdit(
                                        account: snapshot.data!, isEdit: true)));
                                setState(() {

                                });
                              },
                            ),
                            const SizedBox(height: 4),
                            Card(
                              elevation: 2,
                              color: Theme.of(context).backgroundColor,
                              child: ListTile(
                                leading: const Icon(Icons.credit_card,
                                    size: 26, color: mainColor),
                                minLeadingWidth: 22,
                                title: const Text(
                                  'Membership',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                subtitle: Text(
                                  getProgress(snapshot.data!.subscriptions),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add,
                                      size: 32, color: mainColor),
                                  onPressed: () {
                                    if (isMembershipInactive(
                                        snapshot.data!.subscriptions)) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddMembership(
                                                      snapshot.data!.email)));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ConfirmDialog(
                                          textConfirmation: 'Add a visit to membership?',
                                          onNo: () => Navigator.pop(context),
                                          onYes: () async {
                                            bool success =
                                                await _visitHttpController
                                                    .addVisitToMembership(
                                                        snapshot.data!);
                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Visit added to membership')));
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                onTap: () async {
                                  //show visits of membership
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Adding single visit',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ConfirmDialog(
                                          textConfirmation: 'Add a single visit?',
                                          onNo: () => Navigator.pop(context),
                                          onYes: () async {
                                            bool success =
                                                await _visitHttpController
                                                    .addSingleVisit(
                                                        snapshot.data!);
                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Single visit added')));
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text(' Add '),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                }),
          ),
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

  String getProgress(List<Subscription> subscriptions) {
    Subscription? subscription;
    if (subscriptions.isNotEmpty) {
      subscription = subscriptions.last;
    }
    if (subscription != null) {
      if (subscription.dateOfEnd.add(const Duration(days: 1))
          .isBefore(DateTime.now())) {
        return 'Expired in ${formatterDate.format(subscription.dateOfEnd)}';
      } else {
        return '${subscription.visits.length}/${subscription.numberOfVisits} '
            'until ${formatterDate.format(subscription.dateOfEnd)}';
      }
    }
    return 'No added';
  }
}
