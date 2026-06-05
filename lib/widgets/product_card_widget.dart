import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// models
import 'package:basic_da_app/models/product_draft.dart';
//providers
import 'package:basic_da_app/providers/workday_provider.dart';

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
            Center(child: Text('${product.name} - ${product.group}')),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio de venta: ${product.price.toString()}'),
                      Text('Cantidad disponible: ${product.stock.toString()}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: lotMode
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog<ProductDraft>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return ProductFormWidget(
                                  initialProduct: product,
                                  editMode: true,
                                );
                              },
                            );
                          },
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
