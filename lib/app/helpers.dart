import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//models
import 'package:basic_da_app/models/item_draft_model.dart';

enum CostType { purchase, budget }

//helpers para registrar lote y productos
double totalPrice(List products) {
  double total = 0.0;
  for (final p in products) {
    final subTotal = p.price * p.stock;
    total += subTotal;
  }
  return total;
}

double totalCost(List products) {
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

double totalSold(List<ItemDraft> items) {
  double total = 0.0;
  for (final i in items) {
    final subTotal = i.unityPrice * i.amount;
    total += subTotal;
  }
  return total;
}

//helper para mostrar fecha perzonalizada
String formatDate(DateTime date) {
  return DateFormat('dd/MMM/yyyy HH:mm').format(date);
}

//validator para el formulario
class StringValidator {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }
}

class NumberValidator {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingrese una cantidad valida';
    }
    if (number <= 0) {
      return 'Debe ser mayor a 0';
    }
    return null;
  }
}

class SubtractionValidator {
  static FormFieldValidator<String> max(double maximum) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Campo obligatorio';
      }

      final number = double.tryParse(value);
      if (number == null) {
        return 'Ingrese una cantidad valida';
      }
      if (number <= 0) {
        return 'Debe ser mayor a 0';
      }
      if (number > maximum) {
        return 'Excede la cantidad actual';
      }
      return null;
    };
  }
}
