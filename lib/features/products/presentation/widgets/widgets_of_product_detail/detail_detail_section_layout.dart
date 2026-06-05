import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailDetailSectionLayout extends StatelessWidget {
  final int detailCount;
  final Function() onAddDetail;
  final Function(int) onDetailRemoved;

  const DetailDetailSectionLayout({
    Key? key,
    required this.detailCount,
    required this.onAddDetail,
    required this.onDetailRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Gap(16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: detailCount,
          itemBuilder: (context, index) => DetailDetailItemLayout(
              index: index,
              detailCount: detailCount,
              onRemove: onDetailRemoved),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onAddDetail,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Add Another Details"),
          ),
        ),
      ],
    );
  }
}

class DetailDetailItemLayout extends StatelessWidget {
  final int index;
  final int detailCount;
  final Function(int) onRemove;

  const DetailDetailItemLayout({
    Key? key,
    required this.index,
    required this.detailCount,
    required this.onRemove,
  }) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Detail ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (detailCount > 1)
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                ),
            ],
          ),
          const Gap(12),
          const TextField(
            decoration: InputDecoration(
              labelText: "Heading",
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(12),
          const TextField(
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
