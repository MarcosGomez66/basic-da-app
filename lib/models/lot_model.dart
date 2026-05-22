import 'package:hive/hive.dart';

part 'lot_model.g.dart';

@HiveType(typeId: 2)
class LotModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final double? budget;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  final DateTime uploadedAt;

  @HiveField(5)
  DateTime? endedAt;

  LotModel({
    required this.id,
    required this.businessId,
    required this.budget,
    this.isActive = true,
    required this.uploadedAt,
    this.endedAt
});
}