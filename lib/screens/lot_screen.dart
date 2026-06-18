import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import 'package:basic_da_app/providers/product_draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

//widgets
import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:basic_da_app/widgets/product_card_widget.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class LotScreen extends StatelessWidget {
  const LotScreen({super.key});

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
    final draftProvider = context.read<ProductDraftProvider>();

    if (draftProvider.products.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await _confirmDiscardDraft(context);

    if (!context.mounted || !shouldDiscard) return;

    draftProvider.clear();
    Navigator.pop(context);
  }

  //helpers para registrar lote y productos
  double _totalPrice(List<ProductDraft> products) {
    double total = 0.0;
    for (final p in products) {
      final subTotal = p.price * p.stock;
      total += subTotal;
    }
    return total;
  }

  double _totalCost(List<ProductDraft> products) {
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

  @override
  Widget build(BuildContext context) {
    final mode = ModalRoute.of(context)!.settings.arguments as String;
    final products = context.watch<ProductDraftProvider>().products;
    final businessId = context.watch<BusinessProvider>().selectedBusiness!.id;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _exitLotScreen(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: mode == 'new' ? Text('Nuevo lote') : Text('Editar lote'),
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
              Text(
                'Lote: ${DateTime.now().toString()}',
                style: TextStyle(fontSize: 15),
              ),
              //boton para agregar producto
              ElevatedButton.icon(
                onPressed: () async {
                  final product = await showDialog<ProductDraft>(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => const ProductFormWidget(),
                  );

                  if (product != null) {
                    context.read<ProductDraftProvider>().add(product);
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
                          final List<ProductDraft> productsReversed = products
                              .reversed
                              .toList();
                          final ProductDraft product = productsReversed[index];

                          return ProductCardWidget(
                            product: product,
                            lotMode: true,
                          );
                        },
                      ),
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
                  child: Text('Limpiar'),
                  onPressed: products.isEmpty
                    ? null
                    : () async {
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
                      context.read<ProductDraftProvider>().clear();
                    }
                  },
                ),
              ),
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return ElevatedButton(
                      child: Text('Registrar'),
                      onPressed: products.isEmpty
                          ? null
                          : () async {
                        final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text('Registrar'),
                              content: Text('Se registraran los productos de forma permanente, desea continuar?'),
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
                                )
                              ],
                            )
                        );
                        if (result == true) {
                          //crear lote
                          final newLot = LotModel(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            businessId: businessId,
                            totalPrice: _totalPrice(products),
                            totalCost: _totalCost(products),
                            totalProducts: products.length,
                            uploaded: DateTime.now(),
                          );
                          await productProvider.createLot(newLot);
                          //subir productos
                          final newProducts = productProvider.createProducts(products, businessId);
                          await productProvider.uploadProducts(newProducts);
                          productProvider.clearCurrentLot();
                          context.read<ProductDraftProvider>().clear();
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}