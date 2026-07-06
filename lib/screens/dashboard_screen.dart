import 'package:flutter/material.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;

    if (business == null) {
      return const Center(child: Text('No hay negocio seleccionado'));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Dashboard general del negocio: ${business.name}'),
      ),
      /*
        Pantalla donde se va a trabajar con todos los datos
      */
    );
  }
}
