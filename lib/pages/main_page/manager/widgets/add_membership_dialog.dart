import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_settings.dart';
import '../../../../controllers/subscription_http_controller.dart';
import '../../../../helpers/constants.dart';
import '../../../../providers/user_settings_provider.dart';

class AddMembershipDialog extends StatefulWidget {
  final String email;
  const AddMembershipDialog(this.email, {Key? key}) : super(key: key);

  @override
  State<AddMembershipDialog> createState() => _AddMembershipDialogState();
}

class _AddMembershipDialogState extends State<AddMembershipDialog> {
  final SubscriptionHttpController _subscriptionHttpController = SubscriptionHttpController.instance;
  final DateFormat formatterDate = DateFormat('dd.MM.yy');
  final DateTime _now = DateTime.now();
  late DateTimeRange _dateRange;
  final TextEditingController _numberOfVisitsController = TextEditingController();
  late ValueNotifier<bool> _numberOfVisitsValidation;

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
    final UserSettings _settings = Provider.of<UserSettingsPr>(context, listen: false).settings;
    _dateRange = DateTimeRange(
      start: _now,
      end: DateTime(_now.year, _now.month + _settings.defaultMembershipTime, _now.day),
    );
    _numberOfVisitsController.text = _settings.defaultMembershipNumber.toString();

    return AlertDialog(
      title: const Text('Добавить абонемент'),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Отмена',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: () async {
            await save(context);
          },
          child: const Text('Сохранить',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Начало: ${formatterDate.format(_dateRange.start)}\n'
                'Конец:   ${formatterDate.format(_dateRange.end)}',
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                child: const Icon(Icons.calendar_today, size: 26),
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
          const SizedBox(height: 8),
          TextField(
            controller: _numberOfVisitsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Кол-во посещений'),
              counterText: '',
            ),
            maxLength: 4,
          ),
        ],
      ),
    );
  }

  Future<void> save(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    bool success = await _subscriptionHttpController.addMembership(
        widget.email,
        _dateRange.start,
        _dateRange.end,
        _numberOfVisitsController.text);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Нет интернет соединения'),
      ));
    }
  }
}
