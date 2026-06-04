import 'dart:convert';

import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/product_model.dart';
import '../../data/repository/local_product_store.dart';
import '../../../categories/data/repository/local_category_store.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

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
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Management",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          _button("Unit Settings", context),
                          const Gap(12),
                          _button("Add New Product", context),
                        ],
                      ),
                    ],
                  ),

                  const Gap(24),

                  // Filter chips (static UI)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        _Chip(label: "All(0)", selected: true),
                        _Chip(label: "Category 1(0)"),
                        _Chip(label: "Category 2(0)"),
                        _Chip(label: "Category 3(0)"),
                      ],
                    ),
                  ),

                  const Gap(16),

                  // Search UI only
                  SizedBox(
                    width: 400,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "search here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const Gap(24),

                  // Product Grid UI only
                  Expanded(
                    child: ValueListenableBuilder<List<ProductModel>>(
                      valueListenable: LocalProductStore.instance.products,
                      builder: (context, products, _) {
                        if (products.isEmpty) {
                          return const Center(child: Text('No products added'));
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final p = products[index];
                            return _ProductCard(product: p);
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

  Widget _button(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == "Add New Product") {
          context.go("/products/productAdd");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;

  const _Chip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2196F3) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  Widget _buildImage() {
    if (product.images.isNotEmpty) {
      final first = product.images.first;
      if (first.startsWith('data:')) {
        try {
          final data = base64Decode(first.split(',').last);
          return Image.memory(data, fit: BoxFit.cover);
        } catch (_) {}
      } else {
        return Image.network(first, fit: BoxFit.cover);
      }
    }
    return const Icon(Icons.image, size: 64, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final matches = LocalCategoryStore.instance.categories
        .where((c) => c.id == product.categoryId)
        .toList();
    final category = matches.isNotEmpty ? matches.first : null;

    return GestureDetector(
      onTap: () => context.go('/products/productDetails', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              clipBehavior: Clip.hardEdge,
              child: _buildImage(),
            ),
            const Gap(8),
            Text(
              product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(4),
            Text(
              product.shortNote,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            const Gap(6),
            Text(
              'Category: ${category?.name ?? '—'}',
              style: const TextStyle(fontSize: 12),
            ),
            const Gap(6),
            Row(
              children: [
                if (product.isHot)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HOT',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  'Variants: ${product.variants.length}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Gap(8),
            // Rating (single double value)
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const Gap(6),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // small note or placeholder for future
                const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
