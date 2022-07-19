// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sportsman.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportsmanAdapter extends TypeAdapter<Sportsman> {
  @override
  final int typeId = 0;

  @override
  Sportsman read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sportsman(
      id: fields[0] as int,
      email: fields[1] as String,
      password: fields[2] as String,
      phone: fields[3] as String,
      firstName: fields[4] as String,
      dateOfBirth: fields[5] as DateTime,
      subscription: fields[6] as Subscription?,
    );
  }

  @override
  void write(BinaryWriter writer, Sportsman obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.dateOfBirth)
      ..writeByte(6)
      ..write(obj.subscription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportsmanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
