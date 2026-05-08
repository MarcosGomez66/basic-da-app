import 'package:flutter/material.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:provider/provider.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;

    if (business == null) {
      return const Center(
        child: Text('No hay negocio seleccionado'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lista de productos'),
      ),
      body: Center(
        child: Text('Lista de todos los productos del negocio: ${business.name}'),
      ),
      /*
        Boton en el appbar(actions) para agregar nuevo producto
        Lista de productos (pulsable para ver detalles y editar)
      */
    );
  }
}