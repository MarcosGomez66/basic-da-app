import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';
//models
import 'package:basic_da_app/models/item_model.dart';
import 'package:basic_da_app/models/product_model.dart';
//providers
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';

class SaleFormWidget extends StatefulWidget {
  final ItemModel? item;
  const SaleFormWidget({super.key, this.item});

  @override
  State<SaleFormWidget> createState() => _SaleFormWidgetState();
}

class _SaleFormWidgetState extends State<SaleFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  late final FocusNode nameFocusNode;
  late ProductModel? selectedProduct;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      selectedProduct = context.read<ProductProvider>().getProductById(widget.item!.productId);
    } else {
      selectedProduct = null;
    }

    nameController = TextEditingController(
      text: selectedProduct?.name ?? '',
    );
    amountController = TextEditingController(
      text: widget.item?.amount.toString() ?? '',
    );
    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;
    final List<ProductModel> products = business == null
    ? []
    : context.watch<ProductProvider>().getProductsByBusiness(business.id);

    return AlertDialog(
      title: Text(
        widget.item != null ? 'Editar producto' : 'Buscar producto',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //nombre
              RawAutocomplete<ProductModel>(
                textEditingController: nameController,
                focusNode: nameFocusNode,
                displayStringForOption: (product) => product.name,
                onSelected: (product) {
                  setState(() {
                    selectedProduct = product;
                  });
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final value = textEditingValue.text.toLowerCase();
                  if (value.isEmpty) return const Iterable.empty();
                  return products.where(
                      (product) => product.name.toLowerCase().contains(value)
                  );
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (_) {
                      setState(() {
                        selectedProduct = null;
                      });
                    },
                    maxLength: 25,
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                    ),
                    validator: StringValidator.required,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return _AutocompleteOptions(options: options, onSelected: onSelected);
                },
              ),
              //cantidad
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  labelText: 'Cantidad'
                ),
                validator: SubtractionValidator.max(selectedProduct?.stock ?? 1.0),
              )
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
            if (selectedProduct == null || nameController.text != selectedProduct!.name) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seleccione un producto valido'))
              );
              return;
            }
            final item = ItemModel(
              productId: selectedProduct!.id,
              lotId: selectedProduct!.lotId,
              amount: double.parse(amountController.text),
              unityPrice: selectedProduct!.price,
            );
            Navigator.pop(context, item);
          },
        )
      ],
    );
  }
}

class _AutocompleteOptions extends StatelessWidget {
  final Iterable<ProductModel> options;
  final ValueChanged<ProductModel> onSelected;

  const _AutocompleteOptions({required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 180,
            maxWidth: 280
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);

              return ListTile(
                dense: true,
                title: Text(option.name),
                subtitle: Text(option.price.toString()),
                trailing: Text(option.stock.toString()),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}