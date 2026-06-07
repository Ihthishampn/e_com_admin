import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/general/utils/themes/app_colors.dart';

Widget pdEmptyState(String msg) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.containrGrey),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(children: [
        const Icon(Icons.inbox_outlined, color: Color(0xFF6B7280), size: 30),
        const Gap(8),
        Text(msg,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
      ]),
    );
