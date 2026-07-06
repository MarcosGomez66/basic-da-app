// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WasteModelAdapter extends TypeAdapter<WasteModel> {
  @override
  final int typeId = 7;

  @override
  WasteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WasteModel(
      id: fields[0] as String,
      businessId: fields[1] as String,
      items: (fields[2] as List).cast<ItemModel>(),
      totalWaste: (fields[3] as num).toDouble(),
      wastedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WasteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalWaste)
      ..writeByte(4)
      ..write(obj.wastedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WasteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
