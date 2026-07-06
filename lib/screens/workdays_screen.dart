import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:basic_da_app/providers/business_provider.dart';
//widgets

class WorkdaysScreen extends StatelessWidget {
  const WorkdaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessId = context.watch<BusinessProvider>().selectedBusiness!.id;
    final workdays = context.watch<WorkdayProvider>().getWorkdays(businessId);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Jornadas')),
      body: ListView.builder(
        itemCount: workdays.length,
        itemBuilder: (context, index) {
          final wd = workdays[index];

          return ListTile(
            title: Text(wd.startTime.toString()),
            subtitle: Text(wd.endTime?.toString() ?? 'Jornada abierta'),
          );
        },
      ),
    );
  }
}
