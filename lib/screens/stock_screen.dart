import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

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

    return Scaffold();
  }
}