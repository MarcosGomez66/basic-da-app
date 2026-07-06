import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/product_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;
    final lots = context.watch<ProductProvider>().getLotByBusiness(
      business!.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/new_lot');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lots.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Lote: ${formatDate(lots[index].uploadedAt)}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit_lot',
                            arguments: lots[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  'Precio total de venta: ${lots[index].totalPrice.toString()}',
                ),
                Text(
                  'Precio total de compra: ${lots[index].totalCost.toString()}',
                ),
                Text(
                  'Ganancia esperada: ${(lots[index].totalPrice - lots[index].totalCost).toString()}',
                ),
                Text('Total de articulos: ${lots[index].totalArticles}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
