import 'dart:developer';

import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_card.dart';
import '../widgets/add_category_dialog.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: Column(children: [
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
                      onPressed: () => _showAddCategoryDialog(context),
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
                  child: StreamBuilder<List<CategoryModel>>(
                    stream:
                        context.read<CategoryProvider>().handleCategoryFetch(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CategoryLoadingGrid();
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      final categories = snapshot.data ?? [];

                      if (categories.isEmpty) {
                        return const Center(
                          child: Text('No categories found'),
                        );
                      }

                      return GridView.builder(
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          log(category.imageUrl);

                          return CategoryCardLayout(
                            categoryId: category.id!,
                            title: category.name,
                            imageUrl: category.imageUrl,
                            imageBytes: null,
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ))
        ]));
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return const AddCategoryDialog();
      },
    );
  }
}

class CategoryLoadingGrid extends StatelessWidget {
  const CategoryLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
