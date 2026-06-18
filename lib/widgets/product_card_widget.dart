import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// models
import 'package:basic_da_app/models/product_draft_model.dart';
// providers
import 'package:basic_da_app/providers/product_draft_provider.dart';
// widgets
import 'package:basic_da_app/widgets/product_form_widget.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductDraft product;
  final bool lotMode;
  const ProductCardWidget({
    super.key,
    required this.product,
    this.lotMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                product.name,
                style: TextStyle(fontSize: 22),
              ),
            ),
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
                            : 'Precio unitario: ${(product.cost / product.stock).round().toString()}'
                      ),
                      Text('Cantidad disponible: ${product.stock.toString()}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: lotMode
                      ? Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final newProduct =
                                    await showDialog<ProductDraft>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => ProductFormWidget(
                                        initialProduct: product,
                                      ),
                                    );
                                if (newProduct != null) {
                                  context.read<ProductDraftProvider>().update(
                                    product,
                                    newProduct,
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => AlertDialog(
                                    title: Text('Borrar'),
                                    content: Text(
                                      'Desea borrar este producto?',
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
                                          context
                                              .read<ProductDraftProvider>()
                                              .remove(product);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Icon(Icons.warning, color: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
