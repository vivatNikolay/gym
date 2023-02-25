import 'package:flutter/material.dart';

import '../../../../helpers/constants.dart';
import '../../../../controllers/account_http_controller.dart';
import '../../../../models/account.dart';
import '../manager_profile.dart';

class CustomSearchDelegate extends SearchDelegate {
  final AccountHttpController _accountHttpController = AccountHttpController.instance;

  CustomSearchDelegate()
      : super(
          searchFieldLabel: 'Поиск спортсмена',
          keyboardType: TextInputType.text,
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
      return const Center(
        child: Text('Введите что-нибудь'),
      );
    }
    return FutureBuilder<List<Account>>(
        future: _accountHttpController.getSportsmenByQuery(query.trim()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Account>? data = snapshot.data;
          if (data!.isEmpty) {
            return const Center(
              child: Text('Не найден'),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  leading: Image.asset('images/profileImg${data[index].iconNum}.png'),
                  title: Text('${data[index].firstName} ${data[index].lastName}'),
                  subtitle: Text(data[index].email),
                  onTap: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => ManagerProfile(email: data[index].email)));
                  },
                ),
              );
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Поиск по имени и фамилии'),
    );
  }
}