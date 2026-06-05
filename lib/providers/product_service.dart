import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
//models
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class ProductService {
  final Box<LotModel> _lotBox = Hive.box<LotModel>('lots');
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');

  //lotes
  Future<void> createLot(LotModel lot) async {
    await _lotBox.put(lot.id, lot);
  }

  Future<void> updateLot(LotModel lot) async {
    await lot.save();
  }

  Future<void> deactivateLot(LotModel lot) async {
    lot.isActive = false;
    lot.ended = DateTime.now();
    await lot.save();
  }

  List<LotModel> getLotByBusiness(String businessId) {
    return _lotBox.values.where((lot) => lot.businessId == businessId && lot.isActive).toList()
        ..sort((a, b) => b.uploaded.compareTo(a.uploaded));
  }

  //productos
  Future<void> createProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> createProducts(List<ProductModel> products) async {
    for (final p in products) {
      await _productBox.put(p.id, p);
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    await product.save();
  }

  Future<void> deactivateProduct(ProductModel product) async {
    product.isActive = false;
    product.ended = DateTime.now();
    await product.save();
  }

  List<ProductModel> getProductsByBusiness(String businessId) {
    return _productBox.values.where((p) => p.businessId == businessId && p.isActive).toList();
  }

  List<ProductModel> getProductsByLot(String businessId) {
    return _productBox.values.where((p) => p.lotId == businessId && p.isActive).toList();
  }
}