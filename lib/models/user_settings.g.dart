// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 6;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      defaultExerciseSets: fields[0] as int,
      defaultExerciseReps: fields[1] as int,
      defaultMembershipTime: fields[2] as int,
      defaultMembershipNumber: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.defaultExerciseSets)
      ..writeByte(1)
      ..write(obj.defaultExerciseReps)
      ..writeByte(2)
      ..write(obj.defaultMembershipTime)
      ..writeByte(3)
      ..write(obj.defaultMembershipNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
