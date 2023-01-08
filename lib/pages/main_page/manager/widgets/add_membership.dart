import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/subscription_http_controller.dart';

class AddMembership extends StatefulWidget {
  final int _accountId;
  const AddMembership(this._accountId, {Key? key}) : super(key: key);

  @override
  State<AddMembership> createState() => _AddMembershipState(_accountId);
}

class _AddMembershipState extends State<AddMembership> {
  final SubscriptionHttpController _subscriptionHttpController = SubscriptionHttpController.instance;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  final int _accountId;
  final TextEditingController _dateOfPurchaseController = TextEditingController();
  final TextEditingController _dateOfEndController = TextEditingController();
  final TextEditingController _numberOfVisitsController = TextEditingController();
  late ValueNotifier<bool> _numberOfVisitsValidation;

  _AddMembershipState(this._accountId);

  @override
  void initState() {
    super.initState();

    _numberOfVisitsValidation = ValueNotifier(true);
  }

  @override
  void dispose() {
    _numberOfVisitsValidation.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check, size: 28),
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              bool success = await _subscriptionHttpController.addMembership(
                  _accountId,
                  formatterDate.parse(_dateOfPurchaseController.text),
                  formatterDate.parse(_dateOfEndController.text),
                  _numberOfVisitsController.text);
              if (success) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No connection'),
                ));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: _dateOfPurchaseController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                label: Text('Enter date of purchase'),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2070),
                );
                if (pickedDate != null) {
                  setState(() =>
                  _dateOfPurchaseController.text =
                      formatterDate.format(pickedDate));
                }
              },
            ),
            TextField(
              controller: _dateOfEndController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                label: Text('Enter date of end'),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2070),
                );
                if (pickedDate != null) {
                  setState(() =>
                  _dateOfEndController.text =
                      formatterDate.format(pickedDate));
                }
              },
            ),
            TextField(
              controller: _numberOfVisitsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Number of visits'),
                icon: Icon(Icons.numbers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}