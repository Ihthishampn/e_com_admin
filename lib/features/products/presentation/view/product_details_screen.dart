import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:e_com_admin/general/widgets/custom_cached_network_image.dart';
import 'package:e_com_admin/general/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController shortNoteController;
  late TextEditingController additionalNoteController;
  String? selectedCategoryId;
  int variantCount = 1;
  int detailCount = 1;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    shortNoteController = TextEditingController();
    additionalNoteController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    shortNoteController.dispose();
    additionalNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C77FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Back"),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Image
                  const Text(
                    "Image",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Gap(8),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: CustomCachedNetworkImage(
                        imageUrl: '',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Gap(24),

                  // Product Name
                  CustomTextField(
                    controller: nameController,
                    hintText: "Enter Product Name",
                    abovetext: "Product Name",
                  ),
                  const Gap(16),

                  // Short Note
                  CustomTextField(
                    controller: shortNoteController,
                    hintText: "Enter Short Note",
                    abovetext: "Short Note",
                  ),
                  const Gap(16),

                  // Category Dropdown
                  _buildCategoryDropdownLayout(),
                  const Gap(24),

                  // Variant Details
                  _buildVariantSectionLayout(),
                  const Gap(24),

                  // Product Details
                  _buildDetailsSectionLayout(),
                  const Gap(24),

                  // Additional Note
                  CustomTextField(
                    controller: additionalNoteController,
                    hintText: "Enter Any Note",
                    abovetext: "Note (If Any)",
                    maxLines: 4,
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdownLayout() {
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
              onChanged: (val) => setState(() => selectedCategoryId = val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSectionLayout() {
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
          itemBuilder: (context, index) => _buildVariantItemLayout(index),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => setState(() => variantCount++),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Add Another Variant"),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantItemLayout(int idx) {
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
                "Variant ${idx + 1}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (variantCount > 1)
                IconButton(
                  onPressed: () => setState(() => variantCount--),
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

  Widget _buildDetailsSectionLayout() {
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
          itemBuilder: (context, index) => _buildDetailItemLayout(index),
        ),
        const Gap(16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => setState(() => detailCount++),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text("Add Another Details"),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItemLayout(int idx) {
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
                "Detail ${idx + 1}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (detailCount > 1)
                IconButton(
                  onPressed: () => setState(() => detailCount--),
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
