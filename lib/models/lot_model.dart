import 'package:hive/hive.dart';

part 'lot_model.g.dart';

@HiveType(typeId: 2)
class LotModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final double totalPrice;

  @HiveField(3)
  final double totalCost;

  @HiveField(4)
  final int totalProducts;

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  final DateTime uploaded;

  @HiveField(7)
  DateTime? ended;

  LotModel({
    required this.id,
    required this.businessId,
    required this.totalPrice,
    required this.totalCost,
    required this.totalProducts,
    this.isActive = true,
    required this.uploaded,
    this.ended
  });
}
