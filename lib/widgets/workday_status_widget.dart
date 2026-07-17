import 'package:basic_da_app/providers/workday_provider.dart';
import 'package:flutter/material.dart';
// models
import 'package:basic_da_app/models/workday_model.dart';
//providers
import 'package:basic_da_app/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class WorkdayStatusWidget extends StatelessWidget {
  final String businessId;
  final WorkdayModel? currentWorkday;
  const WorkdayStatusWidget({
    super.key,
    required this.businessId,
    required this.currentWorkday,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = currentWorkday?.isOpen ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatusText(isOpen: isOpen),
        const SizedBox(height: 8),
        StatusButton(businessId: businessId, isOpen: isOpen),
        const SizedBox(height: 8),
        TextButton(
          child: const Text('Ver todas las Jornadas'),
          onPressed: () {
            Navigator.pushNamed(context, '/workdays');
          },
        ),
      ],
    );
  }
}

class StatusText extends StatelessWidget {
  final bool isOpen;
  const StatusText({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      isOpen ? 'Jornada Abierta' : 'Jornada Cerrada',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: isOpen ? colorScheme.primary : colorScheme.error,
      ),
    );
  }
}

class StatusButton extends StatelessWidget {
  final String businessId;
  final bool isOpen;
  const StatusButton({
    super.key,
    required this.businessId,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final workdayProvider = context.read<WorkdayProvider>();
        if (!isOpen) {
          await workdayProvider.startWorkday(businessId: businessId);
          return;
        }
        final confirm = await ConfirmDialog.show(
          context,
          title: 'Cerrar jornada',
          message: 'Seguro que desea terminar la jornada?',
        );
        if (confirm) {
          await workdayProvider.endWorkday();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Jornada Finalizada')),
            );
          }
        }
      },
      child: Text(isOpen ? 'Terminar jornada' : 'Iniciar jornada'),
    );
  }
}
