import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/visit.dart';
import '../widgets/membership_progress.dart';
import '../../../http/account_http_service.dart';
import '../../../models/membership.dart';
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
  final String id;

  const ManagerProfile({required this.id, Key? key}) : super(key: key);

  @override
  State<ManagerProfile> createState() => _ManagerProfileState();
}

class _ManagerProfileState extends State<ManagerProfile> {
  final AccountHttpService _accountHttpService = AccountHttpService();
  late String _id;
  late Future<Account>? _futureAccount;
  bool _addMembershipEnabled = true;
  bool _addVisitEnabled = true;
  var _isInit = true;
  late Account _managerAcc;

  _ManagerProfileState();

  @override
  void initState() {
    super.initState();

    _id = widget.id;
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
      _futureAccount = _accountHttpService.getSportsman(_managerAcc, _id);
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
                        return Center(
                            child: Text(
                          snapshot.error!.toString(),
                          style: const TextStyle(fontSize: 23.0),
                        ));
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
                                                account: snapshot.data!)));
                                _updateSportsman();
                              },
                            ),
                            const SizedBox(height: 4),
                            Card(
                              elevation: 2,
                              child: StreamBuilder(
                                  stream:
                                  Membership.getMembershipStreamByUser(
                                          snapshot.data!.id),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          memSnapshot) {
                                    Membership? membership;
                                    if (memSnapshot.connectionState == ConnectionState.waiting) {
                                      return const ListTile(
                                        title: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    if (!memSnapshot.hasError &&
                                        memSnapshot.hasData && memSnapshot.data!.docs.isNotEmpty) {
                                      membership = Membership.fromDocument(
                                          memSnapshot.data!.docs.first);
                                    }
                                    return ListTile(
                                      leading: const Icon(CustomIcons.sub,
                                          size: 26, color: mainColor),
                                      minLeadingWidth: 22,
                                      title: const Text(
                                        'Абонемент',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      subtitle: MembershipProgress(
                                        membership: membership,
                                      ),
                                      trailing: AbsorbPointer(
                                        absorbing: !_addMembershipEnabled,
                                        child: IconButton(
                                          icon: const Icon(Icons.add,
                                              size: 32, color: mainColor),
                                          onPressed: () async {
                                            setState(() =>
                                                _addMembershipEnabled = false);
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            if (_isMembershipInactive(
                                                membership)) {
                                              if (_checkStartDate(
                                                  membership)) {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AddMembershipDialog(
                                                            snapshot.data!.id));
                                              }
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AbsorbPointer(
                                                  absorbing: !_addVisitEnabled,
                                                  child: ConfirmDialog(
                                                    textConfirmation:
                                                        'Добавить посещение в абонемент?',
                                                    onNo: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    onYes: () async {
                                                      setState(() =>
                                                          _addVisitEnabled =
                                                              false);
                                                      try {
                                                        await _addMembershipVisit(
                                                            snapshot.data!.id,
                                                            membership!);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Посещение добавлено в абонемент')));
                                                        Navigator.of(context)
                                                            .pop();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(e
                                                                    .toString())));
                                                      }
                                                      setState(() =>
                                                          _addVisitEnabled =
                                                              true);
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                            setState(() =>
                                                _addMembershipEnabled = true);
                                          },
                                        ),
                                      ),
                                      onTap: () {
                                        if (membership != null) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VisitsList(
                                                        title:
                                                            'История абонемента',
                                                        accountId:
                                                            snapshot.data!.id,
                                                        membershipId:
                                                          membership!.id,
                                                      )));
                                        }
                                      },
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      showDialog(
                                        context: context,
                                        builder: (context) => AbsorbPointer(
                                          absorbing: !_addVisitEnabled,
                                          child: ConfirmDialog(
                                            textConfirmation:
                                                'Добавить разовое?',
                                            onNo: () =>
                                                Navigator.of(context).pop(),
                                            onYes: () async {
                                              setState(() =>
                                                  _addVisitEnabled = false);
                                              ScaffoldMessenger.of(context)
                                                  .clearSnackBars();
                                              try {
                                                await Visit.addVisit(
                                                    snapshot.data!.id, null);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Добавлено разовое посещение')));
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            e.toString())));
                                              }
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

  bool _isMembershipInactive(Membership? membership) {
    if (membership == null) {
      return true;
    }
    if (membership.dateOfEnd.isBefore(DateTime.now()) ||
        membership.dateOfStart.isAfter(DateTime.now()) ||
        membership.visitCounter >= membership.numberOfVisits) {
      return true;
    }
    return false;
  }

  bool _checkStartDate(Membership? membership) {
    if (membership == null) {
      return true;
    }
    if (membership.dateOfStart.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Абонемент не начат'),
      ));
      return false;
    }
    return true;
  }

  Future<void> _addMembershipVisit(String userId, Membership membership) async {
    int newVisitCounter = membership.visitCounter + 1;
    await Membership.updateMembership(membership.id, newVisitCounter);
    await Visit.addVisit(userId, membership.id);
  }
}