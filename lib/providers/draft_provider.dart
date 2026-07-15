import 'package:flutter/material.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/product_model.dart';

class DraftProvider extends ChangeNotifier {

  //borrador de productos
  final List<ProductDraft> _productDrafts = [];

  List<ProductDraft> get productDrafts => List.unmodifiable(_productDrafts);

  void addProduct(ProductDraft product) {
    _productDrafts.add(product);
    notifyListeners();
  }

  void updateProduct(ProductDraft oldProduct, ProductDraft newProduct) {
    final index = _productDrafts.indexOf(oldProduct);

    if (index != -1) {
      _productDrafts[index] = newProduct;
      notifyListeners();
    }
  }

  void removeProduct(ProductDraft product) {
    _productDrafts.remove(product);
    notifyListeners();
  }

  void clearProducts() {
    _productDrafts.clear();
    notifyListeners();
  }

  //borrador de items de venta
  final List<ItemModel> _itemDrafts = [];

  List<ItemModel> get itemDrafts => List.unmodifiable(_itemDrafts);

  void addItem(ItemModel item) {
    _itemDrafts.add(item);
    notifyListeners();
  }

  void updateItem(ItemModel oldItem, ItemModel newItem) {
    final index = _itemDrafts.indexOf(oldItem);

    if (index != -1) {
      _itemDrafts[index] = newItem;
      notifyListeners();
    }
  }

  void removeItem(ItemModel item) {
    _itemDrafts.remove(item);
    notifyListeners();
  }

  void clearItems() {
    _itemDrafts.clear();
    notifyListeners();
  }

  //stock disponible considerando borrador
  double availableStock(ProductModel product) {
    final reserved = _itemDrafts
        .where((e) => e.productId == product.id)
        .fold<double>(0, (sum, e) => sum + e.amount);
    return product.stock - reserved;
  }

  double availableStockForEdition(ProductModel product, ItemModel editing) {
    final reserved = _itemDrafts
        .where((e) => e.productId == product.id)
        .fold<double>(0, (sum, e) => sum + e.amount);
    return product.stock - reserved + editing.amount;
  }
}
