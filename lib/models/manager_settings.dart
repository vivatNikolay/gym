import 'package:hive/hive.dart';

part 'manager_settings.g.dart';

@HiveType(typeId: 8)
class ManagerSettings extends HiveObject {
  @HiveField(0)
  int defaultMembershipTime;
  @HiveField(1)
  int defaultMembershipNumber;

  ManagerSettings({
    this.defaultMembershipTime = 1,
    this.defaultMembershipNumber = 10
  });
}
