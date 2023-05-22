import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/constants.dart';
import '../../../../models/custom_icons.dart';
import '../../../../models/membership.dart';
import '../../../../models/visit.dart';
import '../../../../services/membership_fire.dart';
import '../../../../services/visit_fire.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/visits_list.dart';
import '../../widgets/membership_progress.dart';
import 'add_membership_dialog.dart';

class ManagerMembershipCard extends StatefulWidget {
  final String userId;

  const ManagerMembershipCard({required this.userId, Key? key})
      : super(key: key);

  @override
  State<ManagerMembershipCard> createState() => _ManagerMembershipCardState();
}

class _ManagerMembershipCardState extends State<ManagerMembershipCard> {
  final MembershipFire _membershipFire = MembershipFire();
  final VisitFire _visitFire = VisitFire();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: StreamBuilder(
          stream: _membershipFire.streamByUser(widget.userId),
          builder: (context, AsyncSnapshot<QuerySnapshot> memSnapshot) {
            Membership? membership;
            if (!memSnapshot.hasError &&
                memSnapshot.hasData &&
                memSnapshot.data!.docs.isNotEmpty) {
              membership =
                  Membership.fromDocument(memSnapshot.data!.docs.first);
            }
            return ListTile(
              leading: const Icon(CustomIcons.sub, size: 26, color: mainColor),
              minLeadingWidth: 22,
              title: const Text(
                'Абонемент',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: MembershipProgress(
                membership: membership,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add, size: 32, color: mainColor),
                onPressed: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (_isMembershipInactive(membership)) {
                    if (_checkStartDate(membership)) {
                      await showDialog(
                          context: context,
                          builder: (context) =>
                              AddMembershipDialog(widget.userId));
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        textConfirmation: 'Добавить посещение в абонемент?',
                        onYes: () async => _addMembershipVisit(
                            widget.userId, membership!, context),
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                if (membership != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisitsList(
                            title: 'История абонемента',
                            accountId: widget.userId,
                            membershipId: membership!.id,
                          )));
                }
              },
            );
          }),
    );
  }

  Future<void> _addMembershipVisit(
      String userId, Membership membership, BuildContext context) async {
    membership.visitCounter += 1;
    await _membershipFire.put(membership);
    await _visitFire.create(Visit(
        date: DateTime.now(), userId: userId, membershipId: membership.id));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Посещение добавлено в абонемент')));
    Navigator.of(context).pop();
  }

  bool _isMembershipInactive(Membership? membership) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (membership == null) {
      return true;
    }
    if (membership.dateOfEnd.isBefore(today)) {
      return true;
    }
    if (membership.dateOfStart.isAfter(today)) {
      return true;
    }
    if (membership.visitCounter >= membership.numberOfVisits) {
      return true;
    }
    return false;
  }

  bool _checkStartDate(Membership? membership) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (membership == null) {
      return true;
    }
    if (membership.dateOfStart.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Абонемент не начат'),
      ));
      return false;
    }
    return true;
  }
}
