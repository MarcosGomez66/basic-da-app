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
  final DateTime uploaded;

  @HiveField(5)
  DateTime? ended;

  LotModel({
    required this.id,
    required this.businessId,
    required this.budget,
    this.isActive = true,
    required this.uploaded,
    this.ended
});
}