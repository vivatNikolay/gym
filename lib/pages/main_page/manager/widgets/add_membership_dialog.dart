import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/membership.dart';
import '../../../../models/user_settings.dart';
import '../../../../helpers/constants.dart';
import '../../../../providers/user_settings_provider.dart';

class AddMembershipDialog extends StatefulWidget {
  final String id;
  const AddMembershipDialog(this.id, {Key? key}) : super(key: key);

  @override
  State<AddMembershipDialog> createState() => _AddMembershipDialogState();
}

class _AddMembershipDialogState extends State<AddMembershipDialog> {
  final DateFormat formatterDate = DateFormat('dd.MM.yy');
  final DateTime _now = DateTime.now();
  late DateTimeRange _dateRange;
  final TextEditingController _numberOfVisitsController = TextEditingController();
  late ValueNotifier<bool> _numberOfVisitsValidation;
  var isInit = true;

  @override
  void initState() {
    super.initState();

    _numberOfVisitsValidation = ValueNotifier(true);
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final UserSettings _settings = Provider.of<UserSettingsPr>(context, listen: false).settings!;
      _dateRange = DateTimeRange(
        start: _now,
        end: DateTime(_now.year, _now.month + _settings.defaultMembershipTime, _now.day),
      );
      _numberOfVisitsController.text = _settings.defaultMembershipNumber.toString();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _numberOfVisitsValidation.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить абонемент'),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
                  FocusManager.instance.primaryFocus?.unfocus();
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
          const SizedBox(height: 10),
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
    if (int.tryParse(_numberOfVisitsController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Кол-во посещений должно быть числом')));
    }
    try {
      await Membership.addMembership(
          widget.id,
          _dateRange.start.millisecondsSinceEpoch,
          _dateRange.end.millisecondsSinceEpoch,
          int.parse(_numberOfVisitsController.text));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
