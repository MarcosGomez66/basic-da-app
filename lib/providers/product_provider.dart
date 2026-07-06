import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/lot_model.dart';
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/waste_model.dart';

class ProductProvider extends ChangeNotifier {
  LotModel? _currentLot;

  LotModel? get currentLot => _currentLot;

  final Box<LotModel> _lotBox = Hive.box<LotModel>('lots');
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');
  final Box<WasteModel> _wasteBox = Hive.box<WasteModel>('wastes');

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
    lot.endedAt = DateTime.now();
    await lot.save();
    final products = getProductsByLot(lot.id);
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
        uploadedAt: DateTime.now(),
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
    product.minStock = newMin;
    await product.save();
    notifyListeners();
  }

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
      await deactivateProduct(product);
    } else {
      await product.save();
    }
    await _wasteBox.put(waste.id, waste);
    notifyListeners();
  }

  Future<void> deactivateProduct(ProductModel product) async {
    product.isActive = false;
    product.endedAt = DateTime.now();
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
