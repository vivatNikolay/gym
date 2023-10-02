import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../widgets/main_scaffold.dart';
import '../../widgets/custom_search_delegate.dart';
import '../../widgets/search_field.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'adminPage'.i18n(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
        child: Column(
          children: [
            SearchField(
              onTap: () => showSearch(
                context: context,
                delegate: CustomSearchDelegate(false),
              ),
            ),
            //TODO: list of managers
          ],
        ),
      ),
    );
  }
}
