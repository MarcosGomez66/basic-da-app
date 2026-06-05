import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//providers
import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';
//widgets
import 'package:basic_da_app/widgets/product_form_widget.dart';
import 'package:basic_da_app/widgets/product_card_widget.dart';
//models
import 'package:basic_da_app/models/product_draft.dart';

class LotScreen extends StatefulWidget {
  const LotScreen({super.key});

  @override
  State<LotScreen> createState() => _LotScreenState();
}

class _LotScreenState extends State<LotScreen> {
  void showProductForm() {
    showDialog<ProductDraft>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ProductFormWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: mode == 'new' ? Text('Nuevo lote') : Text('Editar lote'),
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
            Text(
              'Lote: ${DateTime.now().toString()}',
              style: TextStyle(fontSize: 15),
            ),
            //boton para agregar producto
            ElevatedButton.icon(
              onPressed: () {
                showProductForm();
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
                child: Text('Cancelar'),
                onPressed: () {
                  //cancelar
                },
              ),
            ),
            Expanded(
              child: ElevatedButton(
                child: Text('Registrar'),
                onPressed: () {
                  //registrar
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
