import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/subscription_http_controller.dart';
import '../../../../helpers/constants.dart';

class AddMembership extends StatefulWidget {
  final String email;
  const AddMembership(this.email, {Key? key}) : super(key: key);

  @override
  State<AddMembership> createState() => _AddMembershipState(email);
}

class _AddMembershipState extends State<AddMembership> {
  final SubscriptionHttpController _subscriptionHttpController = SubscriptionHttpController.instance;
  final DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  final String _email;
  DateTimeRange _dateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 60)),
  );
  final TextEditingController _numberOfVisitsController = TextEditingController();
  late ValueNotifier<bool> _numberOfVisitsValidation;

  _AddMembershipState(this._email);

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
                  _email,
                  _dateRange.start,
                  _dateRange.end,
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
            Row(
              children: [
                Text(
                  'Start date: ${formatterDate.format(_dateRange.start)}\n'
                  'End date: ${formatterDate.format(_dateRange.end)}',
                  style: const TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  child: const Icon(Icons.calendar_today, size: 28),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: mainColor,
                  ),
                  onPressed: () async {
                    DateTimeRange? newDateRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: _dateRange,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 731)),
                    );
                    if (newDateRange != null) {
                      setState(() => _dateRange = newDateRange);
                    }
                  },
                ),
              ],
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
