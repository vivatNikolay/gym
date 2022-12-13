import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
  ];

  CustomSearchDelegate()
      : super(
          searchFieldLabel: 'Search sportsman',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  // first overwrite to
  // clear the search text
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

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    if (query.length > 1) {
      for (var fruit in searchTerms) {
        if (fruit.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(fruit);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [''];
    if (query.length > 1) {
      for (var fruit in searchTerms) {
        if (fruit.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(fruit);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return query.length > 1
              ? Container()
              : const Padding(
                  padding: EdgeInsets.fromLTRB(7, 7, 0, 0),
                  child: Text('Type at least 2 symbols'),
                );
        }
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }
}