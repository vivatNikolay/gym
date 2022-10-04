// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemSettingsAdapter extends TypeAdapter<SystemSettings> {
  @override
  final int typeId = 5;

  @override
  SystemSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemSettings(
      isDark: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SystemSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isDark);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
