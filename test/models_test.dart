import 'package:flutter_test/flutter_test.dart';

import 'package:basic_da_app/app/helpers.dart';
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/waste_model.dart';

void main() {
  test('calcula totales de venta y costo desde borradores', () {
    final products = [
      const ProductDraft(
        name: 'Producto 1',
        group: 'Grupo',
        stock: 2,
        minStock: 1,
        price: 100,
        costType: CostType.purchase,
        cost: 40,
      ),
      const ProductDraft(
        name: 'Producto 2',
        group: 'Grupo',
        stock: 3,
        minStock: 1,
        price: 50,
        costType: CostType.budget,
        cost: 90,
      ),
    ];

    expect(totalPrice(products), 350);
    expect(totalCost(products), 170);
  });

  test('WasteModel usa items estructurados', () {
    final waste = WasteModel(
      id: 'waste-1',
      businessId: 'business-1',
      items: const [
        ItemModel(
          productId: 'product-1',
          lotId: 'lot-1',
          amount: 2,
          unityPrice: 100,
        ),
      ],
      totalWaste: 200,
      wastedAt: DateTime(2026),
    );

    expect(waste.items.single.productId, 'product-1');
    expect(waste.totalWaste, 200);
  });
}
