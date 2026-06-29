import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class ProductProvider extends ChangeNotifier {
  LotModel? _currentLot;

  LotModel? get currentLot => _currentLot;

  final Box<LotModel> _lotBox = Hive.box<LotModel>('lots');
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');

  //lotes
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
    lot.ended = DateTime.now();
    await lot.save();
    notifyListeners();
  }

  List<LotModel> getLotByBusiness(String businessId) {
    return _lotBox.values
        .where((lot) => lot.businessId == businessId && lot.isActive)
        .toList()
      ..sort((a, b) => b.uploaded.compareTo(a.uploaded));
  }

  //productos
  List<ProductModel> createProducts(
    List<ProductDraft> products,
    String businessId,
  ) {
    final List<ProductModel> productList = [];
    for (final p in products) {
      final newProduct = ProductModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        businessId: businessId,
        lotId: _currentLot!.id,
        name: p.name,
        group: p.group,
        price: p.price,
        costType: p.costType,
        cost: p.cost,
        stock: p.stock,
        minStock: p.minStock,
        uploaded: DateTime.now(),
      );
      productList.add(newProduct);
    }
    return productList;
  }

  Future<void> uploadProducts(List<ProductModel> products) async {
    for (final p in products) {
      await _productBox.put(p.id, p);
    }
    notifyListeners();
  }

  Future<void> updateProduct({
    required ProductModel product,
    required String newName,
    required String newGroup,
    required double newMin,
  }) async {
    product.name = newName;
    product.group = newGroup;
    await product.save();
    notifyListeners();
  }

  Future<void> subtractProduct({required ProductModel product, required double subtrahend}) async {
    product.stock -= subtrahend;
    if (product.stock == 0.0) {
      await deactivateProduct(product);
    } else {
      await product.save();
      notifyListeners();
    }
  }

  Future<void> deactivateProduct(ProductModel product) async {
    product.isActive = false;
    product.ended = DateTime.now();
    await product.save();
    notifyListeners();
  }

  List<ProductModel> getProductsByBusiness(String businessId) {
    return _productBox.values
        .where((p) => p.businessId == businessId && p.isActive)
        .toList();
  }

  List<ProductModel> getProductsByLot(String lotId) {
    return _productBox.values
        .where((p) => p.lotId == lotId && p.isActive)
        .toList();
  }
}
