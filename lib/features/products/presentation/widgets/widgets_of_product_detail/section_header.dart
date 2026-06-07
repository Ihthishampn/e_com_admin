import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/general/utils/themes/app_colors.dart';

class PDSectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const PDSectionHeader({required this.label, required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
                color: AppColors.blue, borderRadius: BorderRadius.circular(2))),
        const Gap(8),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF1A1F36))),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12)),
          child: Text('$count',
              style: const TextStyle(
                  color: Color(0xFF4361EE),
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
