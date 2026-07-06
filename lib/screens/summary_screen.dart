import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';
//widgets
import 'package:basic_da_app/widgets/workday_status_widget.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessId = context.watch<BusinessProvider>().selectedBusiness!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Consumer<WorkdayProvider>(
          builder: (context, workdayProvider, child) {
            return Column(
              children: [
                WorkdayStatusWidget(
                  businessId: businessId,
                  currentWorkday: workdayProvider.currentWorkday,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
