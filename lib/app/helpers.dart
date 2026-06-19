import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';

enum CostType { purchase, budget }

//helpers para registrar lote y productos
double totalPrice(List<ProductDraft> products) {
  double total = 0.0;
  for (final p in products) {
    final subTotal = p.price * p.stock;
    total += subTotal;
  }
  return total;
}

double totalCost(List<ProductDraft> products) {
  double total = 0.0;
  for (final p in products) {
    if (p.costType == CostType.purchase) {
      final subTotal = p.cost * p.stock;
      total += subTotal;
    } else {
      total += p.cost;
    }
  }
  return total;
}

//helper para mostrar fecha perzonalizada
String formatDate(DateTime date) {
  return DateFormat('dd/MMM/yyyy HH:mm').format(date);
}

//helper para usar product_card_widget correctamente
abstract class ProductBase {
  String get name;
  String get group;
  double get price;
  CostType get costType;
  double get cost;
  double get stock;
  double get minStock;
}