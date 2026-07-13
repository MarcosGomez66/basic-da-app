import 'package:hive/hive.dart';
import 'package:basic_da_app/app/helpers.dart';


class CostTypeAdapter extends TypeAdapter<CostType> {
  @override
  final int typeId = 5;

  @override
  CostType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CostType.purchase;
      case 1:
        return CostType.budget;
      default:
        return CostType.purchase;
    }
  }

  @override
  void write(BinaryWriter writer, CostType obj) {
    switch (obj) {
      case CostType.purchase:
        writer.writeByte(0);
        break;
      case CostType.budget:
        writer.writeByte(1);
        break;
    }
  }
}

class ProductDraft {
  final String name;
  final String group;
  final double price; //precio de venta
  final CostType costType;
  final double cost; //precio de compra o presupuesto
  final double stock;
  final double minStock;

  const ProductDraft({
    required this.name,
    required this.group,
    required this.price,
    required this.costType,
    required this.cost,
    required this.stock,
    this.minStock = 0.0,
  });
}
