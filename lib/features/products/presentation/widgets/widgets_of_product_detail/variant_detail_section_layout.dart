import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VariantDetailSectionLayout extends StatelessWidget {
  final int variantCount;
  final Function() onAddVariant;
  final Function(int) onVariantRemoved;

  const VariantDetailSectionLayout({
    super.key,
    required this.variantCount,
    required this.onAddVariant,
    required this.onVariantRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Variant Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Gap(16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: variantCount,
          itemBuilder: (context, index) => VariantDetailItemLayout(
              index: index,
              variantCount: variantCount,
              onRemove: onVariantRemoved),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onAddVariant,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Add Another Variant"),
          ),
        ),
      ],
    );
  }
}

class VariantDetailItemLayout extends StatelessWidget {
  final int index;
  final int variantCount;
  final Function(int) onRemove;

  const VariantDetailItemLayout({
    super.key,
    required this.index,
    required this.variantCount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Variant ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (variantCount > 1)
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          const Gap(12),
          const Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "MRP",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Gap(12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Selling Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Gap(12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Stock Qty",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
