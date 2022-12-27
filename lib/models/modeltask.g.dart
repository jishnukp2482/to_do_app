// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modeltask.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class modeltaskAdapter extends TypeAdapter<modeltask> {
  @override
  final int typeId = 0;

  @override
  modeltask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return modeltask(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      createdattime: fields[3] as DateTime,
      createdatdate: fields[4] as DateTime,
      iscompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, modeltask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.createdattime)
      ..writeByte(4)
      ..write(obj.createdatdate)
      ..writeByte(5)
      ..write(obj.iscompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is modeltaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
