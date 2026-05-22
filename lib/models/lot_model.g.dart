// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LotModelAdapter extends TypeAdapter<LotModel> {
  @override
  final int typeId = 2;

  @override
  LotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LotModel(
      id: fields[0] as String,
      businessId: fields[1] as String,
      budget: fields[2] as double?,
      isActive: fields[3] as bool,
      uploadedAt: fields[4] as DateTime,
      endedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LotModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.budget)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.uploadedAt)
      ..writeByte(5)
      ..write(obj.endedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
