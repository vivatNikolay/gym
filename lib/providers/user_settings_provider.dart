import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_settings.dart';

class UserSettingsPr extends ChangeNotifier {

  UserSettings? _settings;

  UserSettings? get settings {
    return _settings;
  }

  Future<void> create(String accountId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('userSettings')
        .doc(accountId)
        .get();
    _settings = UserSettings.fromDocument(doc);
    notifyListeners();
  }

  Future<void> put(UserSettings settings, String accountId) async {
    _settings = settings;
    await FirebaseFirestore.instance
        .collection('userSettings')
        .doc(accountId)
        .set({
      'defaultMembershipTime': settings.defaultMembershipTime,
      'defaultMembershipNumber': settings.defaultMembershipNumber,
      'defaultExerciseSets': settings.defaultExerciseSets,
      'defaultExerciseReps': settings.defaultExerciseReps,
    });
    notifyListeners();
  }
}
