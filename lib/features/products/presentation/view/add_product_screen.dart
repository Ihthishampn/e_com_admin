import 'package:e_com_admin/general/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:developer';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'package:e_com_admin/features/products/presentation/provider/product_provider.dart';
import 'package:e_com_admin/features/products/presentation/provider/add_product_provider.dart';
import 'package:e_com_admin/general/core/injection/injection.dart';
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
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return ChangeNotifierProvider<AddProductProvider>(
      create: (_) => getIt<AddProductProvider>(),
      child: Builder(builder: (context) {
        final addProv = context.watch<AddProductProvider>();

        // If editing, trigger provider prefill after the first frame.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.isEditing && widget.productId.isNotEmpty) {
            try {
              context.read<AddProductProvider>().initForEdit(widget.productId);
            } catch (_) {}
          }
        });

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
                  selectedImages: addProv.selectedImages,
                  existingImageUrls: addProv.existingImageUrls,
                  onImagesSelected: (newImages) =>
                      addProv.addSelectedImages(newImages),
                  onImageRemoved: (bytes) => addProv.removeSelectedImage(bytes),
                  onRemoteImageRemoved: (url) =>
                      addProv.removeExistingImage(url),
                ),
                const Gap(32),
                CustomTextField(
                  controller: addProv.nameController,
                  hintText: "Enter Product Full Name",
                  abovetext: "Product Name",
                ),
                const Gap(16),
                CustomTextField(
                  controller: addProv.shortNoteController,
                  hintText: "Short Note",
                  abovetext: "Short Note",
                ),
                const Gap(16),
                StreamBuilder<List<CategoryModel>>(
                  stream:
                      context.read<CategoryProvider>().handleCategoryFetch(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // ignore: avoid_print
                      print(
                          'AddProduct category stream error: ${snapshot.error}');
                      log('AddProduct category stream error',
                          error: snapshot.error);
                      return CategoryDropdownLayout(
                        selectedCategoryId: addProv.selectedCategoryId,
                        onChanged: (val) => addProv.setSelectedCategory(val),
                        items: const [],
                      );
                    }

                    final categoryItems = snapshot.data
                            ?.map((category) => DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Text(category.name),
                                ))
                            .toList() ??
                        [];

                    return CategoryDropdownLayout(
                      selectedCategoryId: addProv.selectedCategoryId,
                      onChanged: (val) => addProv.setSelectedCategory(val),
                      items: categoryItems,
                    );
                  },
                ),
                const Gap(32),
                if (widget.isEditing && !addProv.prefilled)
                  const Center(child: CircularProgressIndicator())
                else
                  VariantSectionLayout(
                    variantCount: addProv.variantCount,
                    initialVariants: addProv.variants,
                    onVariantRemoved: (index) => addProv.removeVariantSlot(),
                    onChanged: (list) => addProv.setVariants(list),
                  ),
                const Gap(32),
                if (widget.isEditing && !addProv.prefilled)
                  const Center(child: CircularProgressIndicator())
                else
                  DetailsSectionLayout(
                    detailCount: addProv.detailCount,
                    initialDetails: addProv.details,
                    onAddDetail: () => addProv.addDetailSlot(),
                    onDetailRemoved: (index) => addProv.removeDetailSlot(),
                    onChanged: (list) => addProv.setDetails(list),
                  ),
                const Gap(32),
                CustomTextField(
                  controller: addProv.additionalNoteController,
                  hintText: "Enter Any Note",
                  abovetext: "Note (If Any)",
                  maxLines: 4,
                ),
                const Gap(12),
                const Text('Rating',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                            value: addProv.rating.floor() >= 1
                                ? addProv.rating.floor()
                                : 1,
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
                              addProv.setRating(intVal.toDouble());
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
                            value: addProv.rating,
                            items: () {
                              final intPart = addProv.rating.floor() >= 1
                                  ? addProv.rating.floor()
                                  : 1;
                              final decimals = [0.0, 0.2, 0.4, 0.6, 0.8];
                              final values = <double>[];
                              for (var d in decimals) {
                                final v = (intPart + d);
                                if (v <= 5.0) {
                                  values
                                      .add(double.parse(v.toStringAsFixed(1)));
                                }
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
                            onChanged: (v) {
                              addProv.setRating(v ?? addProv.rating);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                SwitchListTile(
                  title: const Text('Is Hot Product'),
                  value: addProv.isHot,
                  onChanged: (v) => addProv.setIsHot(v),
                ),
                const Gap(40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final productName =
                                addProv.nameController.text.trim();
                            final shortNote =
                                addProv.shortNoteController.text.trim();
                            final categoryId = addProv.selectedCategoryId;

                            if (productName.isEmpty) {
                              toastification.show(
                                title: const Text('Validation'),
                                description:
                                    const Text('Product name is required'),
                                backgroundColor: Colors.orange,
                              );
                              return;
                            }

                            if (shortNote.isEmpty) {
                              toastification.show(
                                title: const Text('Validation'),
                                description:
                                    const Text('Short note is required'),
                                backgroundColor: Colors.orange,
                              );
                              return;
                            }

                            if (categoryId == null || categoryId.isEmpty) {
                              toastification.show(
                                title: const Text('Validation'),
                                description:
                                    const Text('Please select a category'),
                                backgroundColor: Colors.orange,
                              );
                              return;
                            }

                            if (addProv.selectedImages.isEmpty &&
                                addProv.existingImageUrls.isEmpty) {
                              toastification.show(
                                title: const Text('Validation'),
                                description: const Text(
                                    'Please select at least one image'),
                                backgroundColor: Colors.orange,
                              );
                              return;
                            }

                            // validate variants/details collected from the child widgets
                            bool areVariantsValid(List variants) {
                              if (variants.isEmpty) return false;
                              for (var i = 0; i < variants.length; i++) {
                                final v = variants[i];
                                if (v.unit.trim().isEmpty ||
                                    v.variant.trim().isEmpty) {
                                  return false;
                                }
                                if (v.sellingPrice <= 0 || v.mrp <= 0) {
                                  return false;
                                }
                              }
                              return true;
                            }

                            bool areDetailsValid(List details) {
                              if (details.isEmpty) return false;
                              for (var i = 0; i < details.length; i++) {
                                final d = details[i];
                                if (d.heading.trim().isEmpty ||
                                    d.content.trim().isEmpty) {
                                  return false;
                                }
                              }
                              return true;
                            }

                            if (!areVariantsValid(addProv.variants)) {
                              toastification.show(
                                title: const Text('Validation'),
                                description: const Text(
                                    'Please provide valid variant entries (unit, variant, MRP and selling price).'),
                                backgroundColor: Colors.orange,
                              );
                              return;
                            }

                            if (!areDetailsValid(addProv.details)) {
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
                              variants: addProv.variants,
                              details: addProv.details,
                              additionalNote:
                                  addProv.additionalNoteController.text.trim(),
                              rating: addProv.rating,
                              isHot: addProv.isHot,
                              searchKeywords: keywordsBuilder(productName),
                            );

                            bool success = false;
                            if (widget.isEditing &&
                                widget.productId.isNotEmpty) {
                              final edited = product.copyWith(
                                id: widget.productId,
                                images: addProv.existingImageUrls,
                              );
                              success =
                                  await provider.handleUpdateProductWithImages(
                                product: edited,
                                newImageBytes: addProv.selectedImages,
                                existingImageUrls: addProv.existingImageUrls,
                              );
                            } else {
                              success =
                                  await provider.handleAddProductWithImages(
                                product: product,
                                imageBytes: addProv.selectedImages,
                              );
                            }

                            if (success) Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: provider.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.isEditing
                                    ? 'Updating...'
                                    : 'Uploading...',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Text(
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
      }),
    );
  }
}
