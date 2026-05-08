import 'package:flutter/material.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
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
        title: Text('${business.name}, resumen'),
      ),
      body: Center(
        child: Text('Resumen del estado del negocio: ${business.name}'),
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