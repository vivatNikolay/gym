// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainingSettingsAdapter extends TypeAdapter<TrainingSettings> {
  @override
  final int typeId = 6;

  @override
  TrainingSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingSettings(
      defaultExerciseSets: fields[0] as int,
      defaultExerciseReps: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrainingSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.defaultExerciseSets)
      ..writeByte(1)
      ..write(obj.defaultExerciseReps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
