import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:basic_da_app/app/helpers.dart';

// models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/product_model.dart';

// providers
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/movements_provider.dart';

// widgets
import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:basic_da_app/widgets/confirm_dialog.dart';

class ProductDraftCardWidget extends StatelessWidget {
  final ProductDraft product;

  const ProductDraftCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text(product.name, style: textTheme.headlineSmall)),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grupo: ${product.group}'),
                      Text('Precio de venta: ${product.price.toString()}'),
                      Text(
                        product.costType == CostType.purchase
                            ? 'Precio de compra: ${product.cost.toString()}'
                            : 'Precio unitario: ${(product.cost / product.stock).round().toString()}',
                      ),
                      Text('Cantidad disponible: ${product.stock.toString()}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final draftProvider = context.read<DraftProvider>();
                          final newProduct = await showDialog<ProductDraft>(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) =>
                                ProductFormWidget(initialProduct: product),
                          );
                          if (newProduct != null) {
                            draftProvider.updateProduct(product, newProduct);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final result = await ConfirmDialog.show(
                            context,
                            title: 'Borrar',
                            message: 'Desea borrar este producto?',
                          );
                          if (result && context.mounted) {
                            context.read<DraftProvider>().removeProduct(product);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text(product.name, style: textTheme.headlineSmall)),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grupo: ${product.group}'),
                      Text('Precio de venta: ${product.price.toString()}'),
                      Text(
                        product.costType == CostType.purchase
                            ? 'Precio de compra: ${product.cost.toString()}'
                            : 'Precio unitario: ${(product.cost / product.stock).round().toString()}',
                      ),
                      Text('Cantidad disponible: ${product.stock.toString()}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final productProvider = context.read<ProductProvider>();
                          final nameController = TextEditingController(
                            text: product.name,
                          );
                          final groupController = TextEditingController(
                            text: product.group,
                          );
                          final minStockController = TextEditingController(
                            text: product.minStock.toString(),
                          );
                          final formKey = GlobalKey<FormState>();

                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: const Text('Modificar'),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      maxLength: 25,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre del producto',
                                      ),
                                      validator: StringValidator.required,
                                    ),
                                    TextFormField(
                                      controller: groupController,
                                      maxLength: 25,
                                      decoration: const InputDecoration(
                                        labelText: 'Grupo',
                                      ),
                                      validator: StringValidator.required,
                                    ),
                                    TextFormField(
                                      controller: minStockController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Cantidad minima',
                                      ),
                                      validator: NumberValidator.required,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text('Guardar'),
                                  onPressed: () {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            ),
                          );
                          if (result == true) {
                            await productProvider.updateProduct(
                              product: product,
                              newName: nameController.text,
                              newGroup: groupController.text,
                              newMin: double.parse(minStockController.text),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.block),
                        onPressed: () async {
                          final movementsProvider =
                              context.read<MovementsProvider>();
                          final controller = TextEditingController(
                            text: product.stock.toString(),
                          );
                          final key = GlobalKey<FormState>();
                          double? subtrahend;

                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: const Text('Merma'),
                              content: Form(
                                key: key,
                                child: TextFormField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Cantidad a descartar',
                                  ),
                                  validator: SubtractionValidator.max(
                                    product.stock,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text('Aceptar'),
                                  onPressed: () {
                                    if (!key.currentState!.validate()) {
                                      return;
                                    }
                                    subtrahend = double.tryParse(
                                      controller.text,
                                    );
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            ),
                          );
                          if (result == true) {
                            await movementsProvider.wasteProduct(
                              product: product,
                              amount: subtrahend!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
