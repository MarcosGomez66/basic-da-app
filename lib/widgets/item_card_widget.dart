import 'package:basic_da_app/widgets/sale_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// models
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/item_model.dart';

// providers
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';

// widgets
import 'package:basic_da_app/widgets/confirm_dialog.dart';

class ItemCardWidget extends StatelessWidget {
  final ItemModel item;

  const ItemCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ProductModel? product = context.read<ProductProvider>().getProductById(item.productId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text(product!.name)),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio de venta: ${item.unityPrice.toString()}'),
                      Text('Cantidad: ${item.amount.toString()}'),
                      Text('Total: ${(item.unityPrice * item.amount).toString()}')
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
                          final newItem = await showDialog<ItemModel>(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => SaleFormWidget(item: item,)
                          );
                          if (newItem != null) {
                            draftProvider.updateItem(item, newItem);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final result = await ConfirmDialog.show(
                            context,
                            title: 'Borrar venta',
                            message: 'Desea borrar esta venta?',
                          );
                          if (result) {
                            if (context.mounted) {
                              context.read<DraftProvider>().removeItem(item);
                            }
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
