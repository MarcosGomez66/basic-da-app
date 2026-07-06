import 'package:hive/hive.dart';
import 'package:basic_da_app/models/item_model.dart';

part 'waste_model.g.dart';

@HiveType(typeId: 7)
class WasteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final List<ItemModel> items;

  @HiveField(3)
  final double totalWaste;

  @HiveField(4)
  final DateTime wastedAt;

  WasteModel({
    required this.id,
    required this.businessId,
    required this.items,
    required this.totalWaste,
    required this.wastedAt,
  });
}
