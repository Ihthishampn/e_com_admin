import 'dart:convert';

import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:e_com_admin/general/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';

/// Read-only product details screen with a clean, friendly layout.
class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _page = 0;

  Widget _buildImageWidget(String src) {
    if (src.startsWith('data:')) {
      try {
        final bytes = base64Decode(src.split(',').last);
        return Image.memory(bytes,
            fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      } catch (_) {
        return const Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey));
      }
    }

    return CustomCachedNetworkImage(imageUrl: src, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Product Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Edit product',
                            onPressed: () {
                              // navigate to add product in edit mode
                              final id = p.id ?? '';
                              context.go(
                                  '/products/productAdd?isEditing=true&productId=$id');
                            },
                            icon: const Icon(Icons.edit, color: Colors.green),
                          ),
                          const Gap(8),
                          IconButton(
                            tooltip: 'Delete product',
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete product'),
                                  content: const Text(
                                      'Are you sure you want to delete this product? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red))),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                // TODO: hook up real delete via provider/use-case
                                toastification.show(
                                  title: const Text('Deleted'),
                                  description: const Text('Product deleted'),
                                  backgroundColor: Colors.red,
                                );
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          const Gap(8),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C77FF)),
                              child: const Text('Back')),
                        ],
                      ),
                    ],
                  ),

                  const Gap(18),

                  // Image carousel
                  SizedBox(
                    height: 260,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: p.images.isEmpty ? 1 : p.images.length,
                            onPageChanged: (i) => setState(() => _page = i),
                            itemBuilder: (context, index) {
                              if (p.images.isEmpty) {
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                      child: Icon(Icons.image_outlined,
                                          size: 64, color: Colors.grey)),
                                );
                              }
                              final src = p.images[index];
                              return _buildImageWidget(src);
                            },
                          ),
                          if (p.images.isNotEmpty)
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(p.images.length, (i) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    height: 6,
                                    width: _page == i ? 24 : 8,
                                    decoration: BoxDecoration(
                                      color: _page == i
                                          ? Colors.white
                                          : Colors.white54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const Gap(18),

                  // Main info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.productName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            Text(p.shortNote,
                                style: const TextStyle(color: Colors.grey)),
                            const Gap(12),

                            // chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                    label: Text(
                                        'Rating ${p.rating.toStringAsFixed(1)}')),
                                if (p.isHot)
                                  Chip(
                                      label: const Text('HOT'),
                                      backgroundColor: Colors.red.shade50),
                              ],
                            ),

                            const Gap(12),

                            // Additional note and category
                            Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Category',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      const Gap(6),
                                      // Show human-friendly category name (lookup via CategoryProvider)
                                      if (p.categoryId.isEmpty)
                                        const Text('Not assigned',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      else
                                        StreamBuilder<List<CategoryModel>>(
                                          stream: context
                                              .read<CategoryProvider>()
                                              .handleCategoryFetch(),
                                          builder: (context, snap) {
                                            final cats = snap.data ?? [];
                                            final cat = cats.firstWhere(
                                              (c) => c.id == p.categoryId,
                                              orElse: () => CategoryModel(
                                                  id: '',
                                                  name: '',
                                                  imageUrl: '',
                                                  createdAt: DateTime.now()),
                                            );
                                            final name = (cat.name.isNotEmpty)
                                                ? cat.name
                                                : 'Uncategorized';
                                            return Text(name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold));
                                          },
                                        ),
                                      const Gap(12),
                                      const Text('Additional Note',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      const Gap(6),
                                      Text(p.additionalNote.isNotEmpty
                                          ? p.additionalNote
                                          : '—'),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // right column stats
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(children: [
                                  const Text('Images',
                                      style: TextStyle(color: Colors.grey)),
                                  const Gap(8),
                                  Text('${p.images.length}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ]),
                              ),
                            ),
                            const Gap(12),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(children: [
                                  const Text('Variants',
                                      style: TextStyle(color: Colors.grey)),
                                  const Gap(8),
                                  Text('${p.variants.length}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Gap(20),

                  // Variants
                  const Text('Variants',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  if (p.variants.isEmpty)
                    const Text('No variants available')
                  else
                    Column(
                        children: p.variants
                            .map((v) => Card(
                                child: ListTile(
                                    title: Text('${v.unit} • ${v.variant}'),
                                    subtitle: Text(
                                        'MRP: ${v.mrp.toStringAsFixed(2)} — Sell: ${v.sellingPrice.toStringAsFixed(2)}'),
                                    trailing: Text('Stock ${v.stock}'))))
                            .toList()),

                  const Gap(20),

                  // Details
                  const Text('Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  if (p.details.isEmpty)
                    const Text('No details available')
                  else
                    Column(
                      children: p.details
                          .map((d) => Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(d.heading,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const Gap(8),
                                      Text(d.content),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
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
}
