import 'package:basic_da_app/widgets/sale_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:basic_da_app/app/helpers.dart';

// models
import 'package:basic_da_app/models/product_model.dart';
import 'package:basic_da_app/models/item_model.dart';

// providers
import 'package:basic_da_app/providers/draft_provider.dart';
import 'package:basic_da_app/providers/product_provider.dart';

// widgets
import 'package:basic_da_app/widgets/confirm_dialog.dart';

class MovementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime date;
  final List<String> details;

  const MovementCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Color iconColor;
    if (icon == Icons.inventory_2) {
      iconColor = colorScheme.primary;
    } else if (icon == Icons.point_of_sale) {
      iconColor = colorScheme.tertiary;
    } else {
      iconColor = colorScheme.error;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  Text(formatDate(date), style: textTheme.bodySmall),
                  for (final detail in details)
                    Text(detail, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
