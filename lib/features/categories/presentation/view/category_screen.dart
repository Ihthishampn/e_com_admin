import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:e_com_admin/general/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';

import 'package:gap/gap.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/category_model.dart';
import '../../data/repository/local_category_store.dart';
import '../../../../general/services/image_service.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Category Management",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showAddCategoryDialog(context, null),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Add New Category"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ValueListenableBuilder<List<CategoryModel>>(
                      valueListenable:
                          LocalCategoryStore.instance.categoriesNotifier,
                      builder: (context, categories, _) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final c = categories[index];
                            return _CategoryCardLayout(
                              categoryId: c.id ?? 'cat_$index',
                              title: c.name,
                              imageUrl: c.imageUrl.isNotEmpty
                                  ? c.imageUrl
                                  : 'https://via.placeholder.com/150',
                              imageBytes: c.imageBytes,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, String? parentId) {
    final nameController = TextEditingController();
    Uint8List? pickedBytes;
    final imageService = ImageServices(FirebaseStorage.instance, ImagePicker());

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: Text(parentId == null ? 'Add Category' : 'Add Subcategory'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const Gap(8),
                if (pickedBytes != null)
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.memory(pickedBytes!, fit: BoxFit.cover),
                  ),
                const Gap(8),
                ElevatedButton(
                  onPressed: () async {
                    final res = await imageService.pickImageFromDevice();
                    res.fold((l) => null, (bytes) {
                      setState(() => pickedBytes = bytes);
                    });
                  },
                  child: const Text('Select Image'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    LocalCategoryStore.instance.addCategory(
                      name: name,
                      parentId: parentId,
                      imageUrl: '',
                      imageBytes: pickedBytes,
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryCardLayout extends StatelessWidget {
  final String categoryId;
  final String title;
  final String imageUrl;
  final Uint8List? imageBytes;

  const _CategoryCardLayout({
    required this.categoryId,
    required this.title,
    required this.imageUrl,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              context.go('/categories/products?id=$categoryId&name=$title');
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: imageBytes != null
                        ? Image.memory(imageBytes!, fit: BoxFit.contain)
                        : CustomCachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => _showDeleteConfirmationMock(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationMock(BuildContext context) {
    // Handled by deletion logic later
  }
}
