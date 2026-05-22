import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String lotId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String group;

  @HiveField(5)
  final double cost;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final double stock;

  @HiveField(8)
  double minStock;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  final DateTime uploadedAt;

  @HiveField(11)
  DateTime? endedAt;

  ProductModel({
    required this.id,
    required this.businessId,
    required this.lotId,
    required this.name,
    required this.group,
    required this.cost,
    required this.price,
    required this.stock,
    this.minStock = 1,
    this. isActive = true,
    required this.uploadedAt,
    this.endedAt
});
}