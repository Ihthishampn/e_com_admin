import 'package:e_com_admin/features/order_return/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class StatusFilters extends StatelessWidget {
  const StatusFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = [
      'ALL',
      'PENDING',
      'ACCEPTED',
      'SHIPPED',
      'DELIVERED',
      'REJECTED',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels
            .map(
              (label) => Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: StatusChip(label: label, selected: label == 'ALL'),
              ),
            )
            .toList(),
      ),
    );
  }
}
