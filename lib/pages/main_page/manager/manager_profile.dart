import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/subscription_progress.dart';
import '../../../http/account_http_service.dart';
import '../../../http/visit_http_service.dart';
import '../../../models/subscription.dart';
import '../../../models/account.dart';
import '../../../models/custom_icons.dart';
import '../../../helpers/constants.dart';
import '../../../providers/account_provider.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/profile_row.dart';
import '../../widgets/visits_list.dart';
import 'manager_profile_edit.dart';
import 'widgets/add_membership_dialog.dart';

class ManagerProfile extends StatefulWidget {
  final String email;

  const ManagerProfile({required this.email, Key? key}) : super(key: key);

  @override
  State<ManagerProfile> createState() => _ManagerProfileState();
}

class _ManagerProfileState extends State<ManagerProfile> {
  final AccountHttpService _accountHttpService = AccountHttpService();
  final VisitHttpService _visitHttpService = VisitHttpService();
  late String email;
  late Future<Account>? _futureAccount;
  bool _addMembershipEnabled = true;
  bool _addVisitEnabled = true;
  var _isInit = true;
  late Account _managerAcc;

  _ManagerProfileState();

  @override
  void initState() {
    super.initState();

    email = widget.email;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _managerAcc = Provider.of<AccountPr>(context, listen: false).account!;
      _updateSportsman();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateSportsman() {
    setState(() {
      _futureAccount = _accountHttpService.getSportsmenByEmail(_managerAcc, email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Спортсмен'),
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
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ManagerProfileEdit(
                                                account: snapshot.data!,
                                                isEdit: true)));
                                _updateSportsman();
                              },
                            ),
                            const SizedBox(height: 4),
                            Card(
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(CustomIcons.sub,
                                    size: 26, color: mainColor),
                                minLeadingWidth: 22,
                                title: const Text(
                                  'Абонемент',
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  SubscriptionProgress.getString(
                                      snapshot.data!.subscriptions),
                                ),
                                trailing: AbsorbPointer(
                                  absorbing: !_addMembershipEnabled,
                                  child: IconButton(
                                    icon: const Icon(Icons.add,
                                        size: 32, color: mainColor),
                                    onPressed: () async {
                                      setState(
                                          () => _addMembershipEnabled = false);
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      if (isMembershipInactive(
                                          snapshot.data!.subscriptions)) {
                                        if (isMembershipStarted(
                                            snapshot.data!.subscriptions)) {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddMembershipDialog(
                                                      snapshot.data!.email));
                                          _updateSportsman();
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AbsorbPointer(
                                            absorbing: !_addVisitEnabled,
                                            child: ConfirmDialog(
                                              textConfirmation:
                                                  'Добавить посещение в абонемент?',
                                              onNo: () =>
                                                  Navigator.of(context).pop(),
                                              onYes: () async {
                                                setState(() => _addVisitEnabled = false);
                                                bool success =
                                                    await _visitHttpService
                                                        .addVisitToMembership(
                                                      snapshot.data!, _managerAcc);
                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Посещение добавлено в абонемент')));
                                                  _updateSportsman();
                                                }
                                                Navigator.of(context).pop();
                                                setState(() => _addVisitEnabled = true);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                      setState(() => _addMembershipEnabled = true);
                                    },
                                  ),
                                ),
                                onTap: () async {
                                  if (snapshot.data!.subscriptions.isNotEmpty) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => VisitsList(
                                                  visits: snapshot
                                                      .data!
                                                      .subscriptions
                                                      .last
                                                      .visits,
                                                  title: 'История абонемента',
                                                )));
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Разовое посещение',
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
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      showDialog(
                                        context: context,
                                        builder: (context) => AbsorbPointer(
                                          absorbing: !_addVisitEnabled,
                                          child: ConfirmDialog(
                                            textConfirmation:
                                                'Добавить разовое?',
                                            onNo: () => Navigator.of(context).pop(),
                                            onYes: () async {
                                              setState(() =>
                                                  _addVisitEnabled = false);
                                              bool success =
                                                  await _visitHttpService
                                                      .addSingleVisit(
                                                    snapshot.data!, _managerAcc);
                                              if (success) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Добавлено разовое посещение')));
                                              }
                                              Navigator.of(context).pop();
                                              setState(() =>
                                                  _addVisitEnabled = true);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Добавить'),
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
      'Нет интернет соединения',
      style: TextStyle(fontSize: 23.0),
    ));
  }

  bool isMembershipInactive(List<Subscription> subscriptions) {
    if (subscriptions.isEmpty) {
      return true;
    }
    Subscription subscription = subscriptions.last;
    if (subscription.dateOfEnd.isBefore(DateTime.now()) ||
        subscription.dateOfStart.isAfter(DateTime.now()) ||
        subscription.visits.length >= subscription.numberOfVisits) {
      return true;
    }
    return false;
  }

  bool isMembershipStarted(List<Subscription> subscriptions) {
    if (subscriptions.isEmpty) {
      return true;
    }
    Subscription subscription = subscriptions.last;
    if (subscription.dateOfStart.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Абонемент не начат'),
      ));
      return false;
    }
    return true;
  }
}
