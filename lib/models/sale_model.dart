import 'package:hive/hive.dart';

part 'sale_model.g.dart';

@HiveType(typeId: 4)
class SaleModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String workdayId;

  @HiveField(3)
  final Map<String, List> products; //{'product_id': [amount, 'product_lot']}

  @HiveField(4)
  final double totalSold;

  @HiveField(5)
  final DateTime soldAt;

  SaleModel({
    required this.id,
    required this.businessId,
    required this.workdayId,
    required this.products,
    required this.totalSold,
    required this.soldAt,
  });
}
