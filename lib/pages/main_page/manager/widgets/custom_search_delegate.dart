import 'package:flutter/material.dart';

import '../../../../controllers/account_http_controller.dart';
import '../../../../models/account.dart';
import '../manager_profile.dart';

class CustomSearchDelegate extends SearchDelegate {
  final AccountHttpController _accountHttpController = AccountHttpController.instance;

  CustomSearchDelegate()
      : super(
          searchFieldLabel: 'Search sportsman',
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
    return FutureBuilder<List<Account>>(
        future: _accountHttpController.getSportsmenByQuery(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Account>? data = snapshot.data;
          return ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.asset('images/profileImg${data?[index].iconNum}.png'),
                  title: Text('${data?[index].firstName}'),
                  subtitle: Text('${data?[index].email}'),
                  onTap: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => ManagerProfile(email: data![index].email)));
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
      child: Text('Search User'),
    );
  }
}