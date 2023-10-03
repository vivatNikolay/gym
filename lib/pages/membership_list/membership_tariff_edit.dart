import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../services/membership_tariff_fire.dart';
import '../../models/membership_tariff.dart';
import '../widgets/loading_buttons/loading_icon_button.dart';
import '../widgets/my_text_form_field.dart';

class MembershipTariffEdit extends StatefulWidget {
  final MembershipTariff? tariff;

  const MembershipTariffEdit({this.tariff, Key? key}) : super(key: key);

  @override
  State<MembershipTariffEdit> createState() => _MembershipTariffEditState();
}

class _MembershipTariffEditState extends State<MembershipTariffEdit> {
  final MembershipTariffFire _membershipTariffFire = MembershipTariffFire();
  final _formKey = GlobalKey<FormState>();
  late MembershipTariff _tariff;
  late bool _isEdit;
  String _name = '';
  int _duration = 0;
  int _numberOfVisits = 0;
  double _price = 0.0;
  String _description = '';
  int _order = 0;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.tariff != null;
    if (_isEdit) {
      _tariff = widget.tariff!;

      _name = _tariff.name;
      _duration = _tariff.duration;
      _numberOfVisits = _tariff.numberOfVisits;
      _price = _tariff.price;
      _description = _tariff.description ?? '';
      _order = _tariff.order;
    }
  }

  void _trySubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_isEdit) {
          await _membershipTariffFire.put(MembershipTariff(
            id: _tariff.id,
            name: _name,
            duration: _duration,
            numberOfVisits: _numberOfVisits,
            price: _price,
            order: _order,
            description: _description,
          ));
          Navigator.of(context).pop();
        } else {
          await _membershipTariffFire.create(MembershipTariff(
            name: _name,
            duration: _duration,
            numberOfVisits: _numberOfVisits,
            price: _price,
            order: _order,
            description: _description,
          ));
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('membership'.i18n()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LoadingIconButton(
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async => _trySubmit(),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 10)
              .copyWith(top: 20),
          children: [
            MyTextFormField(
              initialValue: _name,
              fieldName: 'name'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.text,
              onSaved: (value) {
                if (value != null) {
                  _name = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _duration.toString(),
              fieldName: 'durationMonth'.i18n(),
              validator: (value) {
                if (value != null && value != '') {
                  if (int.tryParse(value) == null) {
                    return 'enterNumber'.i18n();
                  }
                  if (int.parse(value) <= 0) {
                    return 'numberShouldBeAboveZero'.i18n();
                  }
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value != '') {
                  _duration = int.parse(value);
                }
              },
              maxLength: 8,
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _numberOfVisits.toString(),
              fieldName: 'numberOfVisits'.i18n(),
              validator: (value) {
                if (value != null && value != '') {
                  if (int.tryParse(value) == null) {
                    return 'enterNumber'.i18n();
                  }
                  if (int.parse(value) <= 0) {
                    return 'numberShouldBeAboveZero'.i18n();
                  }
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value != '') {
                  _numberOfVisits = int.parse(value);
                }
              },
              maxLength: 8,
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _price.toString(),
              fieldName: 'price'.i18n(),
              validator: (value) {
                if (value != null && value != '') {
                  if (double.tryParse(value) == null) {
                    return 'enterNumber'.i18n();
                  }
                  if (double.parse(value) <= 0) {
                    return 'numberShouldBeAboveZero'.i18n();
                  }
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value != '') {
                  _price = double.parse(value);
                }
              },
              maxLength: 8,
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _order.toString(),
              fieldName: 'order'.i18n(),
              validator: (value) {
                if (value != null && value != '') {
                  if (int.tryParse(value) == null) {
                    return 'enterNumber'.i18n();
                  }
                  if (int.parse(value) <= 0) {
                    return 'numberShouldBeAboveZero'.i18n();
                  }
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value != '') {
                  _order = int.parse(value);
                }
              },
              maxLength: 8,
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _description,
              fieldName: 'description'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.start,
              numberOfLines: 4,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.text,
              onSaved: (value) {
                if (value != null) {
                  _description = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
