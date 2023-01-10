// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 0;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      email: fields[0] as String,
      lastName: fields[1] as String,
      password: fields[2] as String,
      phone: fields[3] as String,
      firstName: fields[4] as String,
      gender: fields[5] as bool,
      iconNum: fields[6] as int,
      dateOfBirth: fields[7] as DateTime,
      subscriptions: (fields[8] as List).cast<Subscription>(),
      role: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.iconNum)
      ..writeByte(7)
      ..write(obj.dateOfBirth)
      ..writeByte(8)
      ..write(obj.subscriptions)
      ..writeByte(9)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
