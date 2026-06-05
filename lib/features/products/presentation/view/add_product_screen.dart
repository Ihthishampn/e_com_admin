import 'dart:typed_data';
import 'package:e_com_admin/general/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'package:e_com_admin/features/products/presentation/provider/product_provider.dart';
import 'package:e_com_admin/general/services/search_keyword_builder.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets_of_add_prodcuts/image_picker_layout.dart';
import '../widgets/widgets_of_add_prodcuts/category_dropdown_layout.dart';
import '../widgets/widgets_of_add_prodcuts/variant_section_layout.dart';
import '../widgets/widgets_of_add_prodcuts/details_section_layout.dart';

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
  List<ProductVariant> variants = [];
  List<ProductDetail> details = [];
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
            ImagePickerLayout(
              selectedImages: selectedImages,
              onImagesSelected: (newImages) =>
                  setState(() => selectedImages = newImages),
              onImageRemoved: (bytes) =>
                  setState(() => selectedImages.remove(bytes)),
            ),
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

            StreamBuilder<List<CategoryModel>>(
              stream: context.read<CategoryProvider>().handleCategoryFetch(),
              builder: (context, snapshot) {
                final categoryItems = snapshot.data
                        ?.map((category) => DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            ))
                        .toList() ??
                    [];

                return CategoryDropdownLayout(
                  selectedCategoryId: selectedCategoryId,
                  onChanged: (val) => setState(() => selectedCategoryId = val),
                  items: categoryItems,
                );
              },
            ),
            const Gap(32),

            VariantSectionLayout(
              variantCount: variantCount,
              onVariantRemoved: (index) => setState(() => variantCount--),
              onChanged: (list) => variants = list,
            ),
            const Gap(32),

            DetailsSectionLayout(
              detailCount: detailCount,
              onAddDetail: () => setState(() => detailCount++),
              onDetailRemoved: (index) => setState(() => detailCount--),
              onChanged: (list) => details = list,
            ),
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
                          final intPart =
                              rating.floor() >= 1 ? rating.floor() : 1;
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
                onPressed: () async {
                  final productName = nameController.text.trim();
                  final shortNote = shortNoteController.text.trim();
                  final categoryId = selectedCategoryId;

                  if (productName.isEmpty) {
                    toastification.show(
                      title: const Text('Validation'),
                      description: const Text('Product name is required'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  if (shortNote.isEmpty) {
                    toastification.show(
                      title: const Text('Validation'),
                      description: const Text('Short note is required'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  if (categoryId == null || categoryId.isEmpty) {
                    toastification.show(
                      title: const Text('Validation'),
                      description: const Text('Please select a category'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  if (selectedImages.isEmpty) {
                    toastification.show(
                      title: const Text('Validation'),
                      description:
                          const Text('Please select at least one image'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  // validate variants/details collected from the child widgets
                  bool _areVariantsValid(List variants) {
                    if (variants.isEmpty) return false;
                    for (var i = 0; i < variants.length; i++) {
                      final v = variants[i];
                      if (v.unit.trim().isEmpty || v.variant.trim().isEmpty)
                        return false;
                      if (v.sellingPrice <= 0 || v.mrp <= 0) return false;
                    }
                    return true;
                  }

                  bool _areDetailsValid(List details) {
                    if (details.isEmpty) return false;
                    for (var i = 0; i < details.length; i++) {
                      final d = details[i];
                      if (d.heading.trim().isEmpty || d.content.trim().isEmpty)
                        return false;
                    }
                    return true;
                  }

                  if (!_areVariantsValid(variants)) {
                    toastification.show(
                      title: const Text('Validation'),
                      description: const Text(
                          'Please provide valid variant entries (unit, variant, MRP and selling price).'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  if (!_areDetailsValid(details)) {
                    toastification.show(
                      title: const Text('Validation'),
                      description: const Text(
                          'Please provide valid detail entries (heading and description).'),
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  final product = ProductModel(
                    productName: productName,
                    shortNote: shortNote,
                    categoryId: categoryId,
                    variants: variants,
                    details: details,
                    additionalNote: additionalNoteController.text.trim(),
                    rating: rating,
                    isHot: isHot,
                    searchKeywords: keywordsBuilder(productName),
                  );

                  final provider = context.read<ProductProvider>();
                  final success = await provider.handleAddProductWithImages(
                    product: product,
                    imageBytes: selectedImages,
                  );
                  if (success) {
                    Navigator.pop(context);
                  }
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
}
