import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

//widgets
import 'package:basic_da_app/widgets/product_card_widget.dart';

//models
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class EditLotScreen extends StatelessWidget {
  const EditLotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as LotModel?;
    final List<ProductModel> products = context
        .watch<ProductProvider>()
        .getProductsByLot(arg!.id);
    final String businessId = context
        .watch<BusinessProvider>()
        .selectedBusiness!
        .id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar lote'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //titulo
            Text('Lote: ${formatDate(arg.uploaded)}'),
            //boton para agregar producto
            SizedBox(height: 5),
            //lista de productos agregados
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No hay productos'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final ProductModel product = products[index];

                        return ProductCardWidget(product: product);
                      },
                    ),
            ),
            //totales
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Precio total de venta: ${totalPrice(products)}'),
                Text('Precio total de compra: ${totalCost(products)}'),
                Text(
                  'Ganancia esperada: ${(totalPrice(products) - totalCost(products)).toString()}',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          spacing: 20,
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text('Desactivar'),
                onPressed: products.isEmpty
                    ? null
                    : () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            title: Text('Desactivar lote'),
                            content: Text(
                              'Se desactivara todo el lote, desea continuar?',
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              ElevatedButton(
                                child: Text('Aceptar'),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          ),
                        );
                        if (result == true) {
                          //desactivar lote
                        }
                      },
              ),
            ),
            Expanded(
              child: ElevatedButton(
                child: Text('Listo'),
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      title: Text('Finalizar'),
                      content: Text('Desea finalizar con el ajuste?'),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Aceptar'),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                  );
                  if (result == true) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
