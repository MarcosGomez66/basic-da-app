import 'package:basic_da_app/models/workday_model.dart';
import 'package:flutter/material.dart';

class Detalles extends StatelessWidget {
  final String businessId;
  final WorkdayModel? workday;
  const Detalles({super.key, required this.businessId, required this.workday});
  
  @override
  Widget build(BuildContext context) {
    if (workday != null) {
      return Column(
        children: [
          Text(businessId),
          Text(workday?.id ?? 'sin jornada'),
          Text(workday?.startTime.toString() ?? 'sin jornada'),
          Text(workday?.businessId.toString() ?? 'sin jornada')
        ],
      );
    }
    return Text(businessId);
  }
}