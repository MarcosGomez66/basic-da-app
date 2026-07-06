import 'package:flutter/material.dart';
import 'package:basic_da_app/providers/business_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final business = context.watch<BusinessProvider>().selectedBusiness;

    if (business == null) {
      return const Center(child: Text('No hay negocio seleccionado'));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Configuración'),
      ),
      body: Center(
        child: Column(

        ),
      ),
    );
  }
}
