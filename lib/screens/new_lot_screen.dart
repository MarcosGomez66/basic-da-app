import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

//widgets
import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:basic_da_app/widgets/product_card_widget.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class NewLotScreen extends StatelessWidget {
  const NewLotScreen({super.key});

  Future<bool> _confirmDiscardDraft(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Salir'),
        content: Text(
          'Se borrara todo el contenido no registrado, Desea continuar?',
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

    return result ?? false;
  }

  Future<void> _exitLotScreen(BuildContext context) async {
    final draftProvider = context.read<DraftProvider>();

    if (draftProvider.products.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await _confirmDiscardDraft(context);

    if (!context.mounted || !shouldDiscard) return;

    draftProvider.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ProductDraft> products = context.watch<DraftProvider>().products;
    final String businessId = context
        .watch<BusinessProvider>()
        .selectedBusiness!
        .id;
    final String now = formatDate(DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _exitLotScreen(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nuevo lote'),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _exitLotScreen(context),
          ),
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
              Text('Lote: $now', style: TextStyle(fontSize: 20)),
              //boton para agregar producto
              ElevatedButton.icon(
                onPressed: () async {
                  final draftProvider = context.read<DraftProvider>();
                  final product = await showDialog<ProductDraft>(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => const ProductFormWidget(),
                  );

                  if (product != null) {
                    draftProvider.add(product);
                  }
                },
                label: Text('Agregar producto'),
                icon: const Icon(Icons.add),
              ),
              //lista de productos agregados
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No hay productos'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final ProductDraft product = products[index];

                          return ProductDraftCardWidget(product: product);
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
                  onPressed: products.isEmpty
                      ? null
                      : () async {
                          final draftProvider = context.read<DraftProvider>();
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text('Limpiar'),
                              content: Text(
                                'Se borrara todo el contenido no registrado, desea continuar?',
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
                            draftProvider.clear();
                          }
                        },
                  child: Text('Limpiar'),
                ),
              ),
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return ElevatedButton(
                      onPressed: products.isEmpty
                          ? null
                          : () async {
                              final draftProvider = context
                                  .read<DraftProvider>();
                              final result = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  title: Text('Registrar'),
                                  content: Text(
                                    'Se registraran los productos de forma permanente, desea continuar?',
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
                                //crear lote
                                final newLot = LotModel(
                                  id: DateTime.now().microsecondsSinceEpoch
                                      .toString(),
                                  businessId: businessId,
                                  totalPrice: totalPrice(products),
                                  totalCost: totalCost(products),
                                  totalArticles: products.fold<double>(
                                    0,
                                    (total, product) => total + product.stock,
                                  ),
                                  uploadedAt: DateTime.now(),
                                );
                                await productProvider.createLot(newLot);
                                //subir productos
                                final newProducts = productProvider
                                    .createProducts(products, businessId);
                                await productProvider.uploadProducts(
                                  newProducts,
                                );
                                productProvider.clearCurrentLot();
                                draftProvider.clear();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                      child: Text('Registrar'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
