import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/general/utils/themes/app_colors.dart';

class PDStatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const PDStatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.containrGrey),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF1A1F36))),
              Text(label,
                  style:
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
