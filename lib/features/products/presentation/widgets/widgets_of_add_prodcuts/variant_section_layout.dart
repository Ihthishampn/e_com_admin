import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';

class VariantSectionLayout extends StatefulWidget {
  final int variantCount;
  final Function(int) onVariantRemoved;
  final Function(List<ProductVariant>) onChanged;

  const VariantSectionLayout({
    Key? key,
    required this.variantCount,
    required this.onVariantRemoved,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VariantSectionLayout> createState() => _VariantSectionLayoutState();
}

class _VariantSectionLayoutState extends State<VariantSectionLayout> {
  final List<TextEditingController> unitCtrls = [];
  final List<TextEditingController> variantCtrls = [];
  final List<TextEditingController> mrpCtrls = [];
  final List<TextEditingController> sellCtrls = [];
  final List<TextEditingController> stockCtrls = [];

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  @override
  void didUpdateWidget(covariant VariantSectionLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variantCount != widget.variantCount) {
      _ensureControllers();
    }
  }

  void _ensureControllers() {
    while (unitCtrls.length < widget.variantCount) {
      unitCtrls.add(TextEditingController());
      variantCtrls.add(TextEditingController());
      mrpCtrls.add(TextEditingController());
      sellCtrls.add(TextEditingController());
      stockCtrls.add(TextEditingController());
    }
    while (unitCtrls.length > widget.variantCount) {
      unitCtrls.removeLast().dispose();
      variantCtrls.removeLast().dispose();
      mrpCtrls.removeLast().dispose();
      sellCtrls.removeLast().dispose();
      stockCtrls.removeLast().dispose();
    }
    _notifyChanged();
  }

  void _notifyChanged() {
    final variants = <ProductVariant>[];
    for (var i = 0; i < unitCtrls.length; i++) {
      final unit = unitCtrls[i].text.trim();
      final variant = variantCtrls[i].text.trim();
      final mrp = double.tryParse(mrpCtrls[i].text.trim()) ?? 0.0;
      final sell = double.tryParse(sellCtrls[i].text.trim()) ?? 0.0;
      final stock = int.tryParse(stockCtrls[i].text.trim()) ?? 0;

      variants.add(ProductVariant(
          unit: unit,
          variant: variant,
          mrp: mrp,
          sellingPrice: sell,
          stock: stock));
    }
    widget.onChanged(variants);
  }

  @override
  void dispose() {
    for (final c in [
      ...unitCtrls,
      ...variantCtrls,
      ...mrpCtrls,
      ...sellCtrls,
      ...stockCtrls
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Variant Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Gap(16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.variantCount,
          itemBuilder: (context, index) => _variantItem(index),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _variantItem(int index) {
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
              if (widget.variantCount > 1)
                IconButton(
                  onPressed: () {
                    widget.onVariantRemoved(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          const Gap(12),
          TextField(
            controller: unitCtrls[index],
            decoration: const InputDecoration(
                labelText: 'Unit', border: OutlineInputBorder()),
            onChanged: (_) => _notifyChanged(),
          ),
          const Gap(12),
          TextField(
            controller: variantCtrls[index],
            decoration: const InputDecoration(
                labelText: 'Variant', border: OutlineInputBorder()),
            onChanged: (_) => _notifyChanged(),
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: mrpCtrls[index],
                  decoration: const InputDecoration(
                      labelText: 'MRP', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _notifyChanged(),
                ),
              ),
              const Gap(12),
              Expanded(
                child: TextField(
                  controller: sellCtrls[index],
                  decoration: const InputDecoration(
                      labelText: 'Selling Price', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _notifyChanged(),
                ),
              ),
              const Gap(12),
              Expanded(
                child: TextField(
                  controller: stockCtrls[index],
                  decoration: const InputDecoration(
                      labelText: 'Stock Qty', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _notifyChanged(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
