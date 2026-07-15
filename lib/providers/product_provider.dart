import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');

  //productos
  List<ProductModel> createProducts(
    List<ProductDraft> products,
    String businessId,
    String lotId,
  ) {
    final List<ProductModel> productList = [];
    for (final p in products) {
      final newProduct = ProductModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        businessId: businessId,
        lotId: lotId,
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

  ProductModel? getProductById(String id) {
    return _productBox.get(id);
  }
}
