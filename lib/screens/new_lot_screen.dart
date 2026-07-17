import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/movements_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

//widgets
import 'package:basic_da_app/widgets/confirm_dialog.dart';
import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:basic_da_app/widgets/product_card_widget.dart';

//models
import 'package:basic_da_app/models/product_draft_model.dart';
import 'package:basic_da_app/models/lot_model.dart';

class NewLotScreen extends StatelessWidget {
  const NewLotScreen({super.key});

  Future<void> _exitLotScreen(BuildContext context) async {
    final draftProvider = context.read<DraftProvider>();

    if (draftProvider.productDrafts.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await ConfirmDialog.show(
      context,
      title: 'Salir',
      message: 'Se borrara todo el contenido no registrado, Desea continuar?',
    );

    if (!context.mounted || !shouldDiscard) return;

    draftProvider.clearProducts();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ProductDraft> products = context
        .watch<DraftProvider>()
        .productDrafts;
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
          title: const Text('Nuevo lote'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _exitLotScreen(context),
          ),
        ),
        body: Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lote: $now',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final draftProvider = context.read<DraftProvider>();
                    final product = await showDialog<ProductDraft>(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => const ProductFormWidget(),
                    );

                    if (product != null) {
                      draftProvider.addProduct(product);
                    }
                  },
                  label: const Text('Agregar producto'),
                  icon: const Icon(Icons.add),
                ),
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
        ),
        bottomNavigationBar: BottomAppBar(
          height: 68,
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: products.isEmpty
                      ? null
                      : () async {
                          final draftProvider = context.read<DraftProvider>();
                          final result = await ConfirmDialog.show(
                            context,
                            title: 'Limpiar',
                            message:
                                'Se borrara todo el contenido no registrado, desea continuar?',
                          );
                          if (result) {
                            draftProvider.clearProducts();
                          }
                        },
                  child: const Text('Limpiar'),
                ),
              ),
              Expanded(
                child: Consumer<MovementsProvider>(
                  builder: (context, movementsProvider, child) {
                    return ElevatedButton(
                      onPressed: products.isEmpty
                          ? null
                          : () async {
                              final draftProvider = context
                                  .read<DraftProvider>();
                              final result = await ConfirmDialog.show(
                                context,
                                title: 'Registrar',
                                message:
                                    'Se registraran los productos de forma permanente, desea continuar?',
                              );
                              if (result) {
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
                                await movementsProvider.createLot(newLot);
                                final newProducts = context
                                    .read<ProductProvider>()
                                    .createProducts(
                                      products,
                                      businessId,
                                      movementsProvider.currentLot!.id,
                                    );
                                await context
                                    .read<ProductProvider>()
                                    .uploadProducts(newProducts);
                                await movementsProvider.clearCurrentLot();
                                draftProvider.clearProducts();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                      child: const Text('Registrar'),
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
