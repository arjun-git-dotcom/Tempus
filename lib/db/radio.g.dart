// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Radio1Adapter extends TypeAdapter<Radio1> {
  @override
  final int typeId = 3;

  @override
  Radio1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Radio1(
      selectedOption: fields[0] as bool,
      id: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Radio1 obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.selectedOption)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Radio1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
