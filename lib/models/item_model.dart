import 'package:hive/hive.dart';

part 'item_model.g.dart';

@HiveType(typeId: 6)
class ItemModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String lotId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final double unityPrice;

  const ItemModel({
    required this.productId,
    required this.lotId,
    required this.amount,
    required this.unityPrice,
  });
}
