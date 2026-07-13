import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/sale_model.dart';

class MovementsProvider extends ChangeNotifier {
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');
  final Box<SaleModel> _saleBox = Hive.box<SaleModel>('sales');

  final List<ItemModel> _itemsDraft = [];
  List<ItemModel> get itemsDraft => List.unmodifiable(_itemsDraft);

  //borrador venta
  void addDraft(ItemModel item) {
    _itemsDraft.add(item);
    notifyListeners();
  }

  void updateDraft(ItemModel oldItem, ItemModel newItem) {
    final index = _itemsDraft.indexOf(oldItem);

    if (index != -1) {
      _itemsDraft[index] = newItem;
      notifyListeners();
    }
  }

  void removeDraft(ItemModel item) {
    _itemsDraft.remove(item);
    notifyListeners();
  }

  void clearDraft() {
    _itemsDraft.clear();
    notifyListeners();
  }

  //venta
  Future<void> registerSale({
    required String businessId,
    required String workdayId,
    required List<ItemModel> items,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Debe haber al menos un item');
    }

    for (final item in items) {
      final product = _productBox.get(item.productId);
      if (product == null) {
        throw StateError('No se encontró el producto ${item.productId}');
      }
      if (product.businessId != businessId) {
        throw StateError(
          'El producto ${item.productId} no pertenece al negocio',
        );
      }
      if (product.stock < item.amount) {
        throw StateError('Stock insuficiente para ${product.name}');
      }
    }

    final sale = SaleModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      businessId: businessId,
      workdayId: workdayId,
      items: items,
      totalSold: items.fold<double>(
        0.0,
        (sum, item) => sum + (item.amount * item.unityPrice),
      ),
      soldAt: DateTime.now(),
    );

    for (final item in items) {
      final product = _productBox.get(item.productId);
      if (product == null) continue;

      product.stock -= item.amount;
      if (product.stock < 0) {
        product.stock = 0;
      }
      await product.save();
    }

    await _saleBox.put(sale.id, sale);
    notifyListeners();
  }

  List<SaleModel> getSalesByBusiness(String businessId) {
    final sales = _saleBox.values
        .where((sale) => sale.businessId == businessId)
        .toList();
    sales.sort((a, b) => b.soldAt.compareTo(a.soldAt));
    return sales;
  }

  List<SaleModel> getSalesByWorkday(String workdayId) {
    final sales = _saleBox.values
        .where((sale) => sale.workdayId == workdayId)
        .toList();
    sales.sort((a, b) => b.soldAt.compareTo(a.soldAt));
    return sales;
  }
}
