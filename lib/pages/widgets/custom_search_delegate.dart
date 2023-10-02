import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../services/account_fire.dart';
import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../main_page/manager/manager_profile.dart';
import 'confirm_dialog.dart';

class CustomSearchDelegate extends SearchDelegate {
  final AccountFire _accountFire = AccountFire();
  final bool sportsmanSearch;

  CustomSearchDelegate(this.sportsmanSearch)
      : super(
          searchFieldLabel: sportsmanSearch ? 'sportsmanSearch'.i18n() : 'search'.i18n(),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: mainColor,
        ),
        child: IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: const Icon(Icons.search, color: Colors.white,),
        ),
      ),
      const SizedBox(width: 5,)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim() == '') {
      return Center(
        child: Text('inputEmail'.i18n()),
      );
    }
    return FutureBuilder(
        future: sportsmanSearch ? _accountFire.findSportsmanByQuery(query) : _accountFire.findByQuery(query),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                    color: mainColor, strokeWidth: 5),
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
              List<Account> data = List.from(snapshot.data!.docs)
                  .map((i) => Account.fromDocument(i))
                  .toList();
              if (data.isEmpty) {
                return Center(
                  child: Text('notFound'.i18n()),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: ListTile(
                      leading: Image.asset(
                          'images/profileImg${data[index].iconNum}.png'),
                      title: Text(
                          '${data[index].firstName} ${data[index].lastName}'),
                      subtitle: Text(data[index].email),
                      onTap: () async {
                        if (sportsmanSearch) {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ManagerProfile(id: data[index].id!)));
                        } else {
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
                                _accountFire.changeRole(data[index].id, data[index].role);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('searchByEmail'.i18n()),
    );
  }
}