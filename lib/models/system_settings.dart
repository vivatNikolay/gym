import 'package:hive/hive.dart';

part 'system_settings.g.dart';

@HiveType(typeId: 5)
class SystemSettings extends HiveObject {
  @HiveField(0)
  bool isDark;
  @HiveField(1)
  int locale;

  SystemSettings({required this.isDark, required this.locale});
}
