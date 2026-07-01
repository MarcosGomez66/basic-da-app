// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleModelAdapter extends TypeAdapter<SaleModel> {
  @override
  final int typeId = 4;

  @override
  SaleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleModel(
      id: fields[0] as String,
      businessId: fields[1] as String,
      workdayId: fields[2] as String,
      products: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<dynamic>())),
      totalSold: fields[4] as double,
      soldAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SaleModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.workdayId)
      ..writeByte(3)
      ..write(obj.products)
      ..writeByte(4)
      ..write(obj.totalSold)
      ..writeByte(5)
      ..write(obj.soldAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
