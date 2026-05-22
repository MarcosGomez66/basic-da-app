// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 3;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      businessId: fields[1] as String,
      lotId: fields[2] as String,
      name: fields[3] as String,
      group: fields[4] as String,
      cost: fields[5] as double,
      price: fields[6] as double,
      stock: fields[7] as double,
      minStock: fields[8] as double,
      isActive: fields[9] as bool,
      uploadedAt: fields[10] as DateTime,
      endedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.lotId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.group)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.minStock)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.uploadedAt)
      ..writeByte(11)
      ..write(obj.endedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
