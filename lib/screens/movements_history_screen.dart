import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_da_app/app/helpers.dart';

//providers
import 'package:basic_da_app/providers/movements_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';

import 'package:basic_da_app/widgets/movement_card_widget.dart';

enum MovementFilter { all, lot, sale, waste }

class MovementsHistoryScreen extends StatefulWidget {
  const MovementsHistoryScreen({super.key});

  @override
  State<MovementsHistoryScreen> createState() => _MovementsHistoryScreenState();
}

class _MovementsHistoryScreenState extends State<MovementsHistoryScreen> {
  MovementFilter _selectedFilter = MovementFilter.all;

  @override
  Widget build(BuildContext context) {
    final businessId = context.read<BusinessProvider>().selectedBusiness!.id;
    final movementsProvider = context.watch<MovementsProvider>();

    final lots = movementsProvider.getLotByBusiness(businessId);
    final sales = movementsProvider.getSalesByBusiness(businessId);
    final wastes = movementsProvider.getWastesByBusiness(businessId);

    final filteredLots =
        _selectedFilter == MovementFilter.all ||
                _selectedFilter == MovementFilter.lot
            ? lots
            : <dynamic>[];
    final filteredSales =
        _selectedFilter == MovementFilter.all ||
                _selectedFilter == MovementFilter.sale
            ? sales
            : <dynamic>[];
    final filteredWastes =
        _selectedFilter == MovementFilter.all ||
                _selectedFilter == MovementFilter.waste
            ? wastes
            : <dynamic>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de movimientos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Lotes'),
                  selected: _selectedFilter == MovementFilter.lot,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = MovementFilter.lot),
                ),
                FilterChip(
                  label: const Text('Ventas'),
                  selected: _selectedFilter == MovementFilter.sale,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = MovementFilter.sale),
                ),
                FilterChip(
                  label: const Text('Mermas'),
                  selected: _selectedFilter == MovementFilter.waste,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = MovementFilter.waste),
                ),
                FilterChip(
                  label: const Text('Todos'),
                  selected: _selectedFilter == MovementFilter.all,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = MovementFilter.all),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildList(filteredLots, filteredSales, filteredWastes),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List lots, List sales, List wastes) {
    if (lots.isEmpty && sales.isEmpty && wastes.isEmpty) {
      return const Center(child: Text('No hay movimientos'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        for (final lot in lots)
          MovementCard(
            icon: Icons.inventory_2,
            title: 'Lote registrado',
            date: lot.uploadedAt,
            details: [
              '${lot.totalArticles.toInt()} artículos',
              'Ganancia: ${lot.totalPrice - lot.totalCost}',
            ],
          ),
        for (final sale in sales)
          MovementCard(
            icon: Icons.point_of_sale,
            title: 'Venta registrada',
            date: sale.soldAt,
            details: [
              '${sale.items.length} producto(s)',
              'Total: ${sale.totalSold}',
            ],
          ),
        for (final waste in wastes)
          MovementCard(
            icon: Icons.delete_outline,
            title: 'Merma registrada',
            date: waste.wastedAt,
            details: [
              '${waste.items.length} producto(s)',
              'Total: ${waste.totalWaste}',
            ],
          ),
      ],
    );
  }
}

