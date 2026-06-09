import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';

class DetailsSectionLayout extends StatefulWidget {
  final int detailCount;
  final Function() onAddDetail;
  final Function(int) onDetailRemoved;
  final Function(List<ProductDetail>) onChanged;
  final List<ProductDetail>? initialDetails;

  const DetailsSectionLayout({
    Key? key,
    required this.detailCount,
    required this.onAddDetail,
    required this.onDetailRemoved,
    required this.onChanged,
    this.initialDetails,
  }) : super(key: key);

  @override
  State<DetailsSectionLayout> createState() => _DetailsSectionLayoutState();
}

class _DetailsSectionLayoutState extends State<DetailsSectionLayout> {
  final List<TextEditingController> headingCtrls = [];
  final List<TextEditingController> contentCtrls = [];

  bool _appliedInitial = false;

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  @override
  void didUpdateWidget(covariant DetailsSectionLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only reset the "applied initial" flag when initialDetails were
    // previously null and now provided. This prevents re-applying initial
    // values during user edits which would clear typed content.
    if (oldWidget.initialDetails == null && widget.initialDetails != null) {
      _appliedInitial = false;
    }

    _ensureControllers();
  }

  void _ensureControllers() {
    while (headingCtrls.length < widget.detailCount) {
      headingCtrls.add(TextEditingController());
      contentCtrls.add(TextEditingController());
    }
    while (headingCtrls.length > widget.detailCount) {
      headingCtrls.removeLast().dispose();
      contentCtrls.removeLast().dispose();
    }
    _notifyChanged();
    if (!_appliedInitial && widget.initialDetails != null) {
      // Only populate initial details when controllers don't already contain
      // user-entered text, to avoid clobbering in-progress edits on rebuild.
      final hasUserText = headingCtrls.any((c) => c.text.trim().isNotEmpty) ||
          contentCtrls.any((c) => c.text.trim().isNotEmpty);
      if (!hasUserText) {
        final list = widget.initialDetails!;
        for (var i = 0; i < list.length && i < headingCtrls.length; i++) {
          headingCtrls[i].text = list[i].heading;
          contentCtrls[i].text = list[i].content;
        }
        _appliedInitial = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifyChanged());
      }
    }
  }

  void _notifyChanged() {
    final details = <ProductDetail>[];
    for (var i = 0; i < headingCtrls.length; i++) {
      final heading = headingCtrls[i].text.trim();
      final content = contentCtrls[i].text.trim();
      details.add(ProductDetail(heading: heading, content: content));
    }
    widget.onChanged(details);
  }

  @override
  void dispose() {
    for (final c in [...headingCtrls, ...contentCtrls]) {
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
          "Product Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Gap(16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.detailCount,
          itemBuilder: (context, index) => _detailItem(index),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              widget.onAddDetail();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Add Another Details"),
          ),
        ),
      ],
    );
  }

  Widget _detailItem(int index) {
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
              if (widget.detailCount > 1)
                IconButton(
                  onPressed: () {
                    widget.onDetailRemoved(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                ),
            ],
          ),
          const Gap(12),
          TextField(
            controller: headingCtrls[index],
            decoration: const InputDecoration(
              labelText: "Heading",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _notifyChanged(),
          ),
          const Gap(12),
          TextField(
            controller: contentCtrls[index],
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (_) => _notifyChanged(),
          ),
        ],
      ),
    );
  }
}
