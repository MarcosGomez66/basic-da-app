import 'package:basic_da_app/app/helpers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//providers
import 'package:basic_da_app/providers/movements_provider.dart';
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:basic_da_app/providers/workday_provider.dart';

//models
import 'package:basic_da_app/models/item_model.dart';

//widget
import 'package:basic_da_app/widgets/confirm_dialog.dart';
import 'package:basic_da_app/widgets/sale_form_widget.dart';
import 'package:basic_da_app/widgets/item_card_widget.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  Future<void> _exitSaleScreen(BuildContext context) async {
    final draftProvider = context.read<DraftProvider>();

    if (draftProvider.itemDrafts.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await ConfirmDialog.show(
      context,
      title: 'Salir',
      message: 'Se descartara la venta, desea continuar',
    );

    if (!context.mounted || !shouldDiscard) return;

    draftProvider.clearItems();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemModel> itemsDraft = context
        .watch<DraftProvider>()
        .itemDrafts;
    final String businessId = context
        .watch<BusinessProvider>()
        .selectedBusiness!
        .id;
    final String now = formatDate(DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _exitSaleScreen(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Venta'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _exitSaleScreen(context),
          ),
        ),
        body: Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Venta: $now', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  label: const Text('Agregar producto'),
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final draftProvider = context.read<DraftProvider>();
                    final item = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => const SaleFormWidget(),
                    );
                    if (item != null) {
                      draftProvider.addItem(item);
                    }
                  },
                ),
                Expanded(
                  child: itemsDraft.isEmpty
                      ? const Center(child: Text('Que vas a vender?'))
                      : ListView.builder(
                          itemCount: itemsDraft.length,
                          itemBuilder: (context, index) {
                            final ItemModel itemDraft = itemsDraft[index];
                            return ItemCardWidget(item: itemDraft);
                          },
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [Text('Total a vender: ${totalSold(itemsDraft)}')],
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
                  onPressed: itemsDraft.isEmpty
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
                            draftProvider.clearItems();
                          }
                        },
                  child: const Text('Limpiar'),
                ),
              ),
              Expanded(
                child: Consumer<DraftProvider>(
                  builder: (context, draftProvider, child) {
                    return ElevatedButton(
                      onPressed: itemsDraft.isEmpty ? null : () async {
                        final draftProvider = context.read<DraftProvider>();
                        final movementProvider = context.read<MovementsProvider>();
                        final workdayProvider = context.read<WorkdayProvider>();
                        final workday = workdayProvider.currentWorkday;

                        if (workday == null) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No hay jornada abierta')),
                          );
                          return;
                        }

                        try {
                          await movementProvider.registerSale(
                            businessId: businessId,
                            workdayId: workday.id,
                            items: itemsDraft,
                          );
                          draftProvider.clearItems();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Venta registrada')),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
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
