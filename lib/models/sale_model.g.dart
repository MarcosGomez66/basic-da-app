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
      items: _readItems(fields[3]),
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
      ..write(obj.items)
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

List<ItemModel> _readItems(dynamic storedItems) {
  if (storedItems is List) {
    return storedItems.cast<ItemModel>();
  }

  if (storedItems is Map) {
    return storedItems.entries.map((entry) {
      final values = entry.value as List;
      return ItemModel(
        productId: entry.key as String,
        amount: (values[0] as num).toDouble(),
        lotId: values[1] as String,
        unityPrice: values.length > 2 ? (values[2] as num).toDouble() : 0,
      );
    }).toList();
  }

  return const [];
}
