import 'package:basic_da_app/app/helpers.dart';
import 'package:basic_da_app/widgets/item_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//providers
import 'package:basic_da_app/providers/movements_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

//models
import 'package:basic_da_app/models/item_model.dart';

//widget
import 'package:basic_da_app/widgets/sale_form_widget.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  Future<bool> _confirmDiscardDraft(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Salir'),
        content: Text('Se descartara la venta, desea continuar'),
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

  Future<void> _exitSaleScreen(BuildContext context) async {
    final movementProvider = context.read<MovementsProvider>();

    if (movementProvider.itemsDraft.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await _confirmDiscardDraft(context);

    if (!context.mounted || !shouldDiscard) return;

    movementProvider.clearDraft();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemModel> itemsDraft = context
        .watch<MovementsProvider>()
        .itemsDraft;
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
          title: Text('Venta'),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _exitSaleScreen(context),
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
              Text('Venta: $now', style: TextStyle(fontSize: 20)),
              //boton para agregar item
              ElevatedButton.icon(
                label: Text('Agregar producto'),
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final movementProvider = context.read<MovementsProvider>();
                  final item = await showDialog<ItemModel>(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => const SaleFormWidget(),
                  );
                  if (item != null) {
                    movementProvider.addDraft(item);
                  }
                },
              ),
              //lista de ventas a registrar
              Expanded(
                child: itemsDraft.isEmpty
                    ? const Center(child: Text('Que vas a vender'))
                    : ListView.builder(
                        itemCount: itemsDraft.length,
                        itemBuilder: (context, index) {
                          final ItemModel itemDraft = itemsDraft[index];
                          return ItemCardWidget(item: itemDraft);
                        },
                      ),
              ),
              //totales
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Text('Total a vender: ${totalSold(itemsDraft)}')],
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
                  onPressed: itemsDraft.isEmpty
                      ? null
                      : () async {
                          final movementProvider = context
                              .read<MovementsProvider>();
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text('Limpiar'),
                              content: Text(
                                'Se borrara todo el contenido no registrado, desea coninuar?',
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
                            movementProvider.clearDraft();
                          }
                        },
                ),
              ),
              Expanded(
                child: Consumer<MovementsProvider>(
                  builder: (context, movementProvider, child) {
                    return ElevatedButton(
                      child: Text('Registrar'),
                      onPressed: itemsDraft.isEmpty ? null : () async {
                        //registra
                      },
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
