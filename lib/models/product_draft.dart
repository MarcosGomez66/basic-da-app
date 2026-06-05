import 'package:flutter/material.dart';

final List<ProductDraft> products = [];

enum CostType { purchase, budget }

enum CardType { show, edit }

class ProductDraft {
  final String name;
  final String group;
  final double price; //precio de venta
  final CostType costType;
  final double? cost; //precio de compra o presupuesto
  final double stock;
  final double minStock;

  const ProductDraft({
    required this.name,
    required this.group,
    required this.price,
    required this.costType,
    required this.cost,
    required this.stock,
    this.minStock = 0.0,
  });
}
