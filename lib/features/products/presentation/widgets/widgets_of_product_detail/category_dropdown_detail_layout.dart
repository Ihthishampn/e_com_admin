import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryDropdownDetailLayout extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String?) onChanged;

  const CategoryDropdownDetailLayout({
    Key? key,
    required this.selectedCategoryId,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add First Category",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
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
              items: const [],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
