import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../services/membership_fire.dart';
import '../../helpers/constants.dart';
import '../../models/membership.dart';
import '../../models/membership_tariff.dart';
import '../../providers/account_provider.dart';
import '../../services/membership_tariff_fire.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/floating_add_button.dart';
import 'widgets/membership_tariff_dialog.dart';
import 'membership_tariff_edit.dart';

class MembershipsPage extends StatefulWidget {
  static const routeName = '/memberships';
  final String? userId;

  const MembershipsPage({this.userId, super.key});

  @override
  State<MembershipsPage> createState() => _MembershipsPageState();
}

class _MembershipsPageState extends State<MembershipsPage> {
  final MembershipTariffFire _membershipTariffFire = MembershipTariffFire();
  final MembershipFire _membershipFire = MembershipFire();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    _stream = _membershipTariffFire.stream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountPr>(context, listen: false).account;
    return Scaffold(
      appBar: AppBar(
        title: Text('memberships'.i18n()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: account?.role == 'ADMIN'
          ? FloatingAddButton(
              text: 'addMembership'.i18n(),
              onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MembershipTariffEdit())),
            )
          : null,
      body: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('membershipsDidNotLoad'.i18n()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<MembershipTariff> tariffs = List.from(snapshot.data!.docs)
                .map((i) => MembershipTariff.fromDocument(i))
                .toList();
            if (tariffs.isNotEmpty) {
              return listView(tariffs, account?.role);
            } else {
              return emptyMess();
            }
          }),
    );
  }

  ListView listView(List<MembershipTariff>? tariffs, String? role) {
    return ListView.builder(
        itemCount: tariffs?.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.75),
            child: ListTile(
              title: Text(tariffs?[index].name ?? ''),
              trailing: role == 'ADMIN'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => MembershipTariffEdit(tariff: tariffs?[index]))),
                          icon: const Icon(Icons.edit, color: mainColor),
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              onYes: () async => _membershipTariffFire.delete(tariffs?[index].id),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    )
                  : widget.userId != null
                      ? IconButton(
                          onPressed: () async {
                            await addMembershipToUser(context, tariffs?[index]);
                          },
                          icon: const Icon(Icons.check_circle, color: mainColor),
                        )
                      : null,
              onTap: () => showDialog(
                context: context,
                builder: (context) => MembershipTariffDialog(tariffs?[index]),
              ),
            ),
          );
        });
  }

  Center emptyMess() {
    return Center(
      child: Text(
        'noMemberships'.i18n(),
        style: const TextStyle(fontSize: 23.0),
      ),
    );
  }

  Future<void> addMembershipToUser(BuildContext context, MembershipTariff? tariff) async {
    if (tariff == null || widget.userId == null) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    DateTime? newPickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      helpText: 'Выберете дату начала',
    );
    if (newPickedDate != null) {
      try {
        await _membershipFire.create(Membership(
          dateOfStart: newPickedDate,
          dateOfEnd: DateTime(newPickedDate.year, newPickedDate.month + tariff.duration, newPickedDate.day),
          numberOfVisits: tariff.numberOfVisits,
          visitCounter: 0,
          userId: widget.userId!,
          creationDate: DateTime.now(),
        ));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }
}
