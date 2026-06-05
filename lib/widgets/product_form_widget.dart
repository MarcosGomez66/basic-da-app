import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//models
import 'package:basic_da_app/models/product_draft.dart';

class ProductFormWidget extends StatefulWidget {
  final ProductDraft? initialProduct;
  final bool editMode;
  const ProductFormWidget({
    super.key,
    this.initialProduct,
    this.editMode = false,
  });

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController groupController;
  late final TextEditingController stockController;
  late final TextEditingController minStockController;
  late final TextEditingController priceController;
  late final TextEditingController costController;

  final formKey = GlobalKey<FormState>();
  CostType costType = CostType.purchase;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialProduct?.name ?? '',
    );
    groupController = TextEditingController(
      text: widget.initialProduct?.group ?? '',
    );
    stockController = TextEditingController(
      text: widget.initialProduct?.stock.toString() ?? '',
    );
    minStockController = TextEditingController(
      text: widget.initialProduct?.minStock.toString() ?? '',
    );
    priceController = TextEditingController(
      text: widget.initialProduct?.price.toString() ?? '',
    );
    costController = TextEditingController(
      text: widget.initialProduct?.cost.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    groupController.dispose();
    stockController.dispose();
    minStockController.dispose();
    priceController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editMode ? 'Editar producto' : 'Ingresar Producto'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //nombre
              TextFormField(
                controller: nameController,
                maxLength: 25,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                validator: StringValidator.required,
              ),
              //grupo
              TextFormField(
                controller: groupController,
                maxLength: 25,
                decoration: InputDecoration(labelText: 'Grupo'),
                validator: StringValidator.required,
              ),
              //cantidad
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(labelText: 'Cantidad'),
                validator: NumberValidator.required,
              ),
              //cantidad minima
              TextFormField(
                controller: minStockController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(labelText: 'Cantidad minima'),
                validator: NumberValidator.required,
              ),
              //precio de venta
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: InputDecoration(labelText: 'Precio de venta'),
                validator: NumberValidator.required,
              ),
              //eleccion de tipo de costo
              RadioGroup<CostType>(
                groupValue: costType,
                onChanged: (CostType? value) {
                  setState(() {
                    costType = value!;
                  });
                },
                child: const Column(
                  children: [
                    RadioListTile<CostType>(
                      title: Text('Precio de compra'),
                      value: CostType.purchase,
                    ),
                    RadioListTile<CostType>(
                      title: Text('Presupuesto'),
                      value: CostType.budget,
                    ),
                  ],
                ),
              ),
              //precio de compra
              TextFormField(
                controller: costController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: InputDecoration(
                  labelText: costType == CostType.purchase
                      ? 'Precio de compra'
                      : 'Presupuesto del producto',
                ),
                validator: NumberValidator.required,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text('Aceptar'),
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            final productDraft = ProductDraft(
              name: nameController.text,
              group: groupController.text,
              stock: double.parse(stockController.text),
              minStock: double.parse(minStockController.text),
              price: double.parse(priceController.text),
              costType: costType,
              cost: double.parse(costController.text),
            );
            if (products.contains(widget.initialProduct)) {
              products.remove(widget.initialProduct);
              products.add(productDraft);
            } else {
              products.add(productDraft);
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

//helpers
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
      return 'Debe ser mayot a 0';
    }
    return null;
  }
}
