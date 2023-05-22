import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../http/account_http_service.dart';
import '../../../models/account.dart';
import '../../../helpers/constants.dart';
import '../../../providers/account_provider.dart';
import '../../widgets/profile_row.dart';
import 'widgets/manager_membership_card.dart';
import 'widgets/single_visit.dart';
import 'manager_profile_edit.dart';

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
                            ManagerMembershipCard(userId: snapshot.data!.id),
                            SingleVisit(userId: snapshot.data!.id),
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
}
