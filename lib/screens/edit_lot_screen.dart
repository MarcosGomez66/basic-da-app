import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/movements_provider.dart';

//widgets
import 'package:basic_da_app/widgets/confirm_dialog.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar lote'),
      ),
      body: Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Lote: ${formatDate(arg.uploadedAt)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Precio total de venta: ${arg.totalPrice.toString()}'),
                  Text('Precio total de compra: ${arg.totalCost.toString()}'),
                  Text(
                    'Ganancia esperada: ${(arg.totalPrice - arg.totalCost).toString()}',
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
                        final movementsProvider = context.read<MovementsProvider>();
                        final result = await ConfirmDialog.show(
                          context,
                          title: 'Desactivar lote',
                          message:
                              'Se desactivara todo el lote, desea continuar?',
                        );
                        if (result) {
                          await movementsProvider.deactivateLot(arg);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                child: const Text('Desactivar'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await ConfirmDialog.show(
                    context,
                    title: 'Finalizar',
                    message: 'Desea finalizar con el ajuste?',
                  );
                  if (result) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Listo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
