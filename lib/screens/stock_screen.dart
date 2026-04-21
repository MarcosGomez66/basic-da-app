import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    final String businessName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lista de productos'),
      ),
      body: Center(
        child: Text('Lista de todos los productos del negocio: $businessName'),
      ),
      /*
        Boton en el appbar(actions) para agregar nuevo producto
        Lista de productos (pulsable para ver detalles y editar)
      */
    );
  }
}