import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//models
import 'package:basic_da_app/models/lot_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/sale_model.dart';
import 'package:basic_da_app/models/waste_model.dart';

class MovementsProvider extends ChangeNotifier {
  final Box<LotModel> _lotBox = Hive.box<LotModel>('lots');
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');
  final Box<SaleModel> _saleBox = Hive.box<SaleModel>('sales');
  final Box<WasteModel> _wasteBox = Hive.box<WasteModel>('wastes');

  //lotes
  LotModel? _currentLot;

  LotModel? get currentLot => _currentLot;

  Future<void> createLot(LotModel lot) async {
    await _lotBox.put(lot.id, lot);
    _currentLot = lot;
    notifyListeners();
  }

  Future<void> clearCurrentLot() async {
    _currentLot = null;
    notifyListeners();
  }

  Future<void> deactivateLot(LotModel lot) async {
    lot.isActive = false;
    lot.endedAt = DateTime.now();
    await lot.save();
    final products = _productBox.values
        .where((p) => p.lotId == lot.id && p.isActive)
        .toList();
    for (final product in products) {
      product.isActive = false;
      product.endedAt = lot.endedAt;
      await product.save();
    }
    notifyListeners();
  }

  List<LotModel> getLotByBusiness(String businessId) {
    return _lotBox.values
        .where((lot) => lot.businessId == businessId && lot.isActive)
        .toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
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

  //merma
  Future<void> wasteProduct({
    required ProductModel product,
    required double amount,
  }) async {
    final waste = WasteModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      businessId: product.businessId,
      items: [
        ItemModel(
          productId: product.id,
          lotId: product.lotId,
          amount: amount,
          unityPrice: product.price,
        ),
      ],
      totalWaste: amount * product.price,
      wastedAt: DateTime.now(),
    );

    product.stock -= amount;
    if (product.stock <= 0.0) {
      product.stock = 0.0;
      product.isActive = false;
      product.endedAt = DateTime.now();
    }
    await product.save();
    await _wasteBox.put(waste.id, waste);
    notifyListeners();
  }

  List<WasteModel> getWastesByBusiness(String businessId) {
    final wastes = _wasteBox.values
        .where((w) => w.businessId == businessId)
        .toList();
    wastes.sort((a, b) => b.wastedAt.compareTo(a.wastedAt));
    return wastes;
  }
}
