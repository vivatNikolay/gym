import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../../services/membership_fire.dart';
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
  final MembershipFire _membershipFire = MembershipFire();
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
        start: DateTime(_now.year, _now.month, _now.day),
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
      title: Text('addMembership'.i18n()),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('cancel'.i18n(),
              style: const TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: () async {
            await save(context);
          },
          child: Text('save'.i18n(),
              style: const TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '${'start'.i18n()}: ${formatterDate.format(_dateRange.start)}\n'
                '${'end'.i18n()}:   ${formatterDate.format(_dateRange.end)}',
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
                    firstDate: DateTime(_now.year, _now.month, _now.day),
                    lastDate: DateTime(_now.year, _now.month, _now.day)
                        .add(const Duration(days: 731)),
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
            decoration: InputDecoration(
              label: Text('numberOfVisits'.i18n()),
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
    if (int.tryParse(_numberOfVisitsController.text) == null ||
        _numberOfVisitsController.text == '0' ||
        _dateRange.duration.inDays == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('createMembershipError'.i18n())));
      Navigator.of(context).pop();
      return;
    }
    try {
      await _membershipFire.create(Membership(
        dateOfStart: _dateRange.start,
        dateOfEnd: _dateRange.end,
        numberOfVisits: int.parse(_numberOfVisitsController.text),
        visitCounter: 0,
        userId: widget.id,
        creationDate: DateTime.now(),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
