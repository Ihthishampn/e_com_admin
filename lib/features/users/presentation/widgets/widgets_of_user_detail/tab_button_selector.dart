import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TabButtonSelector extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;

  const TabButtonSelector({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tabButton('Orders', 0),
        const Gap(8),
        _tabButton('Refund & Return', 1),
      ],
    );
  }

  Widget _tabButton(String label, int index) {
    bool isSelected = selectedTabIndex == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
