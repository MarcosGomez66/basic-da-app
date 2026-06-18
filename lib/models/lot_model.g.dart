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
      totalPrice: fields[2] as double,
      totalCost: fields[3] as double,
      totalProducts: fields[4] as int,
      isActive: fields[5] as bool,
      uploaded: fields[6] as DateTime,
      ended: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LotModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.totalPrice)
      ..writeByte(3)
      ..write(obj.totalCost)
      ..writeByte(4)
      ..write(obj.totalProducts)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.uploaded)
      ..writeByte(7)
      ..write(obj.ended);
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
