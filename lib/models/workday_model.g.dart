// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workday_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkdayModelAdapter extends TypeAdapter<WorkdayModel> {
  @override
  final int typeId = 1;

  @override
  WorkdayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkdayModel(
      id: fields[0] as String,
      businessId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      isOpen: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkdayModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.isOpen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkdayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
