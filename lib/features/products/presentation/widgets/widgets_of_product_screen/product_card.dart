import 'dart:convert';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'package:e_com_admin/general/widgets/custom_cached_network_image.dart';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  Widget _buildImage() {
    if (product.images.isNotEmpty) {
      final first = product.images.first;
      if (first.startsWith('data:')) {
        try {
          final data = base64Decode(first.split(',').last);
          return Image.memory(data, fit: BoxFit.contain);
        } catch (_) {}
      } else {
        return CustomCachedNetworkImage(imageUrl: first, fit: BoxFit.contain);
      }
    }
    return const Icon(Icons.image, size: 64, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/products/productDetails', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImage(),
              ),
            ),
            const Gap(6),
            Text(
              product.productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const Gap(4),
            Text(
              product.shortNote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Gap(4),
            const Text('Category: ', style: TextStyle(fontSize: 12)),
            const Gap(4),
            if (product.categoryId.isEmpty) ...[
              const Text('Not assigned',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ] else ...[
              Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder<List<CategoryModel>>(
                  stream:
                      context.read<CategoryProvider>().handleCategoryFetch(),
                  builder: (context, snap) {
                    final cats = snap.data ?? [];
                    final cat = cats.firstWhere(
                      (c) => c.id == product.categoryId,
                      orElse: () => CategoryModel(
                          id: '',
                          name: '',
                          imageUrl: '',
                          createdAt: DateTime.now()),
                    );
                    final name =
                        (cat.name.isNotEmpty) ? cat.name : 'Uncategorized';
                    return Text(name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis);
                  },
                ),
              ),
            ],
            const Gap(6),
            Row(children: [
              if (product.isHot)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('HOT',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
              const Spacer(),
              Text('Variants: ${product.variants.length}',
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ]),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
