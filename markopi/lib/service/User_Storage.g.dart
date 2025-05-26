// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User_Storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      namaLengkap: fields[0] as String,
      email: fields[1] as String,
      provinsi: fields[2] as String,
      kabupaten: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.namaLengkap)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.provinsi)
      ..writeByte(3)
      ..write(obj.kabupaten);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
