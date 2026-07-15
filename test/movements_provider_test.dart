import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:basic_da_app/app/helpers.dart';
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/sale_model.dart';
import 'package:basic_da_app/models/lot_model.dart';
import 'package:basic_da_app/models/waste_model.dart';
import 'package:basic_da_app/providers/movements_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final tempDir = await Directory.systemTemp.createTemp(
      'movements_provider_test',
    );
    Hive.init(tempDir.path);
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CostTypeAdapter());
    Hive.registerAdapter(ItemModelAdapter());
    Hive.registerAdapter(SaleModelAdapter());
    Hive.registerAdapter(LotModelAdapter());
    Hive.registerAdapter(WasteModelAdapter());

    await Hive.openBox<ProductModel>('products');
    await Hive.openBox<SaleModel>('sales');
    await Hive.openBox<LotModel>('lots');
    await Hive.openBox<WasteModel>('wastes');
  });

  tearDown(() async {
    await Hive.close();
  });

  test('registra una venta y descuenta el stock del producto', () async {
    final product = ProductModel(
      id: 'product-1',
      businessId: 'business-1',
      lotId: 'lot-1',
      name: 'Pan',
      group: 'Almacén',
      price: 100,
      costType: CostType.purchase,
      cost: 80,
      stock: 3,
      minStock: 1,
      uploadedAt: DateTime(2026, 1, 1),
    );
    await Hive.box<ProductModel>('products').put(product.id, product);

    final provider = MovementsProvider();
    await provider.registerSale(
      businessId: 'business-1',
      workdayId: 'workday-1',
      items: const [
        ItemModel(
          productId: 'product-1',
          lotId: 'lot-1',
          amount: 2,
          unityPrice: 100,
        ),
      ],
    );

    final saleBox = Hive.box<SaleModel>('sales');
    expect(saleBox.values.length, 1);
    expect(saleBox.values.single.totalSold, 200);

    final updatedProduct = Hive.box<ProductModel>('products').get('product-1');
    expect(updatedProduct!.stock, 1);
  });
}
