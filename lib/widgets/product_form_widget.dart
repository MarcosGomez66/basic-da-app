import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';
//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';
//providers
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';

class ProductFormWidget extends StatefulWidget {
  final ProductDraft? initialProduct;
  const ProductFormWidget({super.key, this.initialProduct});

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
  late final FocusNode nameFocusNode;
  late final FocusNode groupFocusNode;

  late CostType costType;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    costType = widget.initialProduct?.costType ?? CostType.purchase;
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
    nameFocusNode = FocusNode();
    groupFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    groupController.dispose();
    stockController.dispose();
    minStockController.dispose();
    priceController.dispose();
    costController.dispose();
    nameFocusNode.dispose();
    groupFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;
    final List<ProductModel> products = business == null
        ? []
        : context.watch<ProductProvider>().getProductsByBusiness(business.id);
    final names = products.map((product) => product.name).toSet().toList();
    final groups = products.map((product) => product.group).toSet().toList();

    return AlertDialog(
      title: Text(
        widget.initialProduct != null ? 'Editar producto' : 'Ingresar Producto',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //nombre
              RawAutocomplete<String>(
                textEditingController: nameController,
                focusNode: nameFocusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final value = textEditingValue.text.toLowerCase();
                  if (value.isEmpty) return const Iterable<String>.empty();
                  return names.where(
                    (name) => name.toLowerCase().contains(value),
                  );
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLength: 25,
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                    ),
                    validator: StringValidator.required,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return _AutocompleteOptions(
                    options: options,
                    onSelected: onSelected,
                  );
                },
              ),
              //grupo
              RawAutocomplete<String>(
                textEditingController: groupController,
                focusNode: groupFocusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final value = textEditingValue.text.toLowerCase();
                  if (value.isEmpty) return const Iterable<String>.empty();
                  return groups.where(
                    (group) => group.toLowerCase().contains(value),
                  );
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLength: 25,
                    decoration: InputDecoration(labelText: 'Grupo'),
                    validator: StringValidator.required,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return _AutocompleteOptions(
                    options: options,
                    onSelected: onSelected,
                  );
                },
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
            Navigator.pop(context, productDraft);
          },
        ),
      ],
    );
  }
}

class _AutocompleteOptions extends StatelessWidget {
  final Iterable<String> options;
  final ValueChanged<String> onSelected;

  const _AutocompleteOptions({required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180, maxWidth: 280),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);

              return ListTile(
                dense: true,
                title: Text(option),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}
