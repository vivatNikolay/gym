// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitAdapter extends TypeAdapter<Visit> {
  @override
  final int typeId = 2;

  @override
  Visit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Visit(
      id: fields[0] as int,
      date: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Visit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
