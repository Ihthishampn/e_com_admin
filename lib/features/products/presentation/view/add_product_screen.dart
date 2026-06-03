import 'dart:typed_data';
import 'package:e_com_admin/general/widgets/add_image_containers.dart';
import 'package:e_com_admin/general/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEditing;
  final String productId;

  const AddProductScreen({
    super.key,
    this.isEditing = false,
    this.productId = '',
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final shortNoteController = TextEditingController();
  final additionalNoteController = TextEditingController();

  List<String> existingImageUrls = [];
  List<Uint8List> selectedImages = [];
  String? selectedCategoryId;

  int variantCount = 1;
  int detailCount = 1;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Product" : "Add New Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
              ),
              child: const Text("Back"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Image",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            _buildImagePickerLayout(),
            const Gap(32),

            CustomTextField(
              controller: nameController,
              hintText: "Enter Product Full Name",
              abovetext: "Product Name",
            ),
            const Gap(16),

            CustomTextField(
              controller: shortNoteController,
              hintText: "Short Note",
              abovetext: "Short Note",
            ),
            const Gap(16),

            _buildCategoryDropdownLayout(),
            const Gap(32),

            _buildVariantSectionLayout(),
            const Gap(32),

            _buildDetailsSectionLayout(),
            const Gap(32),

            CustomTextField(
              controller: additionalNoteController,
              hintText: "Enter Any Note",
              abovetext: "Note (If Any)",
              maxLines: 4,
            ),
            const Gap(40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.isEditing ? "UPDATE" : "UPLOAD",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerLayout() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        GestureDetector(
          onTap: () {},
          child: const SizedBox(
            width: 120,
            height: 120,
            child: AddImageContainer(
              width: 120,
              height: 120,
              aspectRatioValue: 1.0,
              aspectRatio: "1:1",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdownLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add First Category",
          style: TextStyle(fontWeight: FontWeight.bold),
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
