import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryDropdownLayout extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;

  const CategoryDropdownLayout({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
    this.items = const [],
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedCategoryId,
              hint: const Text("Select Category"),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
