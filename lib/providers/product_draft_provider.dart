import 'package:flutter/material.dart';
//models
import 'package:basic_da_app/models/product_draft_model.dart';

class ProductDraftProvider extends ChangeNotifier {
  final List<ProductDraft> _products = [];

  List<ProductDraft> get products => List.unmodifiable(_products);

  void add(ProductDraft product) {
    _products.add(product);
    notifyListeners();
  }

  void update(ProductDraft oldProduct, ProductDraft newProduct) {
    final index = _products.indexOf(oldProduct);

    if (index != -1) {
      _products[index] = newProduct;
      notifyListeners();
    }
  }

  void remove(ProductDraft product) {
    _products.remove(product);
    notifyListeners();
  }

  void clear() {
    _products.clear();
    notifyListeners();
  }
}
