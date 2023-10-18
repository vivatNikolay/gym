import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';
import '../../../models/account.dart';
import '../../../services/account_fire.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_search_delegate.dart';
import '../../widgets/search_field.dart';

final AccountFire _accountFire = AccountFire();

class ManagersList extends StatelessWidget {
  const ManagersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: [
          SearchField(
            onTap: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(false),
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _accountFire.streamManagers(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(color: mainColor, strokeWidth: 5),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error!.toString()),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<Account> data = List.from(snapshot.data!.docs).map((i) => Account.fromDocument(i)).toList();
                  if (data.isEmpty) {
                    return Container();
                  }
                  return Column(
                    children: List.generate(
                      data.length,
                      (index) => Card(
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                        elevation: 2.0,
                        child: ListTile(
                          leading: Image.asset('images/profileImg${data[index].iconNum}.png'),
                          title: Text(
                            '${data[index].firstName} ${data[index].lastName}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(data[index].email),
                          onTap: () async {
                            String textConfirmation = '';
                            if (data[index].role == 'MANAGER') {
                              textConfirmation = 'Назначить роль спортсмена?';
                            } else if (data[index].role == 'USER') {
                              textConfirmation = 'Назначить роль менеджера?';
                            }
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                textConfirmation: textConfirmation,
                                onYes: () async {
                                  await _accountFire.changeRole(data[index].id, data[index].role);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
