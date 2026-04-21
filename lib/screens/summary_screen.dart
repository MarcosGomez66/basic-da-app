import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final String businessName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('$businessName, resumen'),
      ),
      body: Center(
        child: Text('Resumen del estado del negocio: $businessName'),
      ),
      /*
        Texto para mostrar estado de la jornada,
        Boton para iniciar o dar por terminado una jornada,
        Si existe una jornada abierta:
          - aviso de productos con bajo stock
          - lista de productos mas vendidos
          - producto mas rentable, etc
        Si no:
          - resumen de jornada anterior
      */
    );
  }
}