import 'package:hive/hive.dart';
import 'package:basic_da_app/app/helpers.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends HiveObject{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String lotId;

  @HiveField(3)
  String name;

  @HiveField(4)
  String group;

  @HiveField(5)
  final double price; //precio de compra

  @HiveField(6)
  final CostType costType;

  @HiveField(7)
  final double cost; // precio de venta, en caso de presupuesto guardar siempre el dato real y solo hacer la division al mostrar

  @HiveField(8)
  double stock; //cantidad

  @HiveField(9)
  double minStock;

  @HiveField(10)
  bool isActive;

  @HiveField(11)
  final DateTime uploaded;

  @HiveField(12)
  DateTime? ended;

  ProductModel({
    required this.id,
    required this.businessId,
    required this.lotId,
    required this.name,
    required this.group,
    required this.price,
    required this.costType,
    required this.cost,
    required this.stock,
    required this.minStock,
    this.isActive = true,
    required this.uploaded,
    this.ended
  });
}
