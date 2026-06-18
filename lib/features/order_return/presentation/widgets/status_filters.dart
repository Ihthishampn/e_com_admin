import 'package:e_com_admin/features/order_return/presentation/provider/order_return_provider.dart';
import 'package:e_com_admin/features/order_return/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusFilters extends StatelessWidget {
  const StatusFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderReturnProvider>();
    final selectedFilter = provider.selectedStatusFilter;

    // Keep only the requested statuses in chips (plus ALL)
    final labels = [
      'ALL',
      'PENDING',
      'ACCEPTED',
      'PACKED',
      'SHIPPED',
      'DELIVERED',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels
            .map(
              (label) => Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: StatusChip(
                  label: label,
                  selected: label == selectedFilter,
                  onSelected: (selected) {
                    if (selected) provider.changeStatusFilter(label);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
