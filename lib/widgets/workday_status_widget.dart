import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:flutter/material.dart';
// models
import 'package:basic_da_app/models/workday_model.dart';
//providers
import 'package:provider/provider.dart';

class WorkdayStatusWidget extends StatelessWidget {
  final String businessId;
  final WorkdayModel? currentWorkday;
  const WorkdayStatusWidget({super.key, required this.businessId, required this.currentWorkday});

  @override
  Widget build(BuildContext context) {
    final isOpen = currentWorkday?.isOpen ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatusText(isOpen: isOpen),
        SizedBox(height: 6),
        StatusButton(businessId: businessId, isOpen: isOpen),
        SizedBox(height: 6),
        TextButton(
          child: Text('Ver todas las Jornadas'),
          onPressed: () {
            Navigator.pushNamed(context, '/workdays');
          },
        )
      ],
    );
  }
}

class StatusText extends StatelessWidget {
  final bool isOpen;
  const StatusText({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Text(
      isOpen ? 'Jornada Abierta' : 'Jornada Cerrada',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isOpen ? Colors.green : Colors.redAccent,
      ),
    );
  }
}

class StatusButton extends StatelessWidget {
  final String businessId;
  final bool isOpen;
  const StatusButton({super.key, required this.businessId, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        //iniciar jornada
        if (!isOpen) {
          await context.read<WorkdayProvider>().startWorkday(businessId: businessId);
          return;
        }
        //terminar jornada
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cerrar jornada'),
              content: const Text('Seguro que desea terminar la jornada?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          }
        );
        if (confirm == true) {
          await context.read<WorkdayProvider>().endWorkday();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jornada Finalizada'),
              ),
            );
          }
        }
      },
      child: Text(
        isOpen ? 'Terminar jornada' : 'Iniciar jornada',
      ),
    );
  }
}