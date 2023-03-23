// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManagerSettingsAdapter extends TypeAdapter<ManagerSettings> {
  @override
  final int typeId = 8;

  @override
  ManagerSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManagerSettings(
      defaultMembershipTime: fields[0] as int,
      defaultMembershipNumber: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ManagerSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.defaultMembershipTime)
      ..writeByte(1)
      ..write(obj.defaultMembershipNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManagerSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
