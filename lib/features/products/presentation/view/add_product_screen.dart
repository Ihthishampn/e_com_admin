import 'dart:typed_data';
import 'dart:convert';
import 'package:e_com_admin/general/widgets/add_image_containers.dart';
import 'package:e_com_admin/general/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/categories/data/repository/local_category_store.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/products/data/repository/local_product_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../general/services/image_service.dart';

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
  bool isHot = false;
  double rating = 1.0;

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
            const Gap(12),
            // Rating selector: two columns (single stored double)
            const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(8),
            Row(
              children: [
                // Integer part (1..5)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: rating.floor() >= 1 ? rating.floor() : 1,
                        items: List.generate(5, (i) => i + 1)
                            .map(
                              (v) => DropdownMenuItem<int>(
                                value: v,
                                child: Text('$v'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          final intVal = v ?? 1;
                          setState(() {
                            // Reset decimal to .0 when integer changes
                            rating = intVal.toDouble();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // Decimal part (optional) shown as combined values (e.g., 1.2)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<double>(
                        value: rating,
                        items: () {
                          final intPart = rating.floor() >= 1
                              ? rating.floor()
                              : 1;
                          final decimals = [0.0, 0.2, 0.4, 0.6, 0.8];
                          final values = <double>[];
                          for (var d in decimals) {
                            final v = (intPart + d);
                            if (v <= 5.0)
                              values.add(double.parse(v.toStringAsFixed(1)));
                          }
                          // ensure integer-only option present
                          if (!values.contains(intPart.toDouble())) {
                            values.insert(0, intPart.toDouble());
                          }
                          return values
                              .map(
                                (v) => DropdownMenuItem<double>(
                                  value: v,
                                  child: Text(v.toStringAsFixed(1)),
                                ),
                              )
                              .toList();
                        }(),
                        onChanged: (v) => setState(() => rating = v ?? rating),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            SwitchListTile(
              title: const Text('Is Hot Product'),
              value: isHot,
              onChanged: (v) => setState(() => isHot = v),
            ),
            const Gap(40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Create a ProductModel from entered fields and add to local store
                  final imagesDataUrls = selectedImages
                      .map((b) => 'data:image/png;base64,${base64Encode(b)}')
                      .toList();

                  final product = ProductModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    productName: nameController.text.trim(),
                    shortNote: shortNoteController.text.trim(),
                    categoryId: selectedCategoryId ?? '',
                    images: imagesDataUrls,
                    variants: [],
                    details: [],
                    additionalNote: additionalNoteController.text.trim(),
                    createdAt: DateTime.now(),
                
                    rating: rating,
                    isHot: isHot,
                  );

                  LocalProductStore.instance.addProduct(product);
                  Navigator.pop(context);
                },
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
          onTap: () async {
            final imageService = ImageServices(
              FirebaseStorage.instance,
              ImagePicker(),
            );
            final res = await imageService.pickMultipleImageFromDevice(
              maxImages: 5,
            );
            res.fold((l) => null, (list) {
              setState(() {
                selectedImages = [...selectedImages, ...list];
              });
            });
          },
          child: SizedBox(
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
        for (var bytes in selectedImages)
          Stack(
            children: [
              Image.memory(bytes, width: 120, height: 120, fit: BoxFit.cover),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () => setState(() => selectedImages.remove(bytes)),
                  child: Container(
                    color: Colors.black45,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCategoryDropdownLayout() {
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
              items: LocalCategoryStore.instance.categories
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c.id,
                      child: Text(
                        c.name + (c.parentId == null ? ' (Main)' : ''),
                      ),
                    ),
                  )
                  .toList(),
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
