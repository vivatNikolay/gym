import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/subscription_http_controller.dart';
import '../../../../helpers/constants.dart';

class AddMembershipDialog extends StatefulWidget {
  final String email;
  const AddMembershipDialog(this.email, {Key? key}) : super(key: key);

  @override
  State<AddMembershipDialog> createState() => _AddMembershipDialogState(email);
}

class _AddMembershipDialogState extends State<AddMembershipDialog> {
  final SubscriptionHttpController _subscriptionHttpController = SubscriptionHttpController.instance;
  final DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  final String _email;
  DateTimeRange _dateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 60)),
  );
  final TextEditingController _numberOfVisitsController = TextEditingController();
  late ValueNotifier<bool> _numberOfVisitsValidation;

  _AddMembershipDialogState(this._email);

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
    return AlertDialog(
      title: const Text('Add membership'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: () async {
            await save(context);
          },
          child: const Text('Save',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Start: ${formatterDate.format(_dateRange.start)}\n'
                'End:   ${formatterDate.format(_dateRange.end)}',
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
    );
  }

  Future<void> save(BuildContext context) async {
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
  }
}
