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
import 'package:e_com_admin/general/utils/themes/app_colors.dart';
import 'package:e_com_admin/features/products/presentation/widgets/widgets_of_product_detail/action_chip.dart';
import 'package:e_com_admin/features/products/presentation/widgets/widgets_of_product_detail/badge.dart';
import 'package:e_com_admin/features/products/presentation/widgets/widgets_of_product_detail/stat_card.dart';
import 'package:e_com_admin/features/products/presentation/widgets/widgets_of_product_detail/section_header.dart';
import 'package:e_com_admin/features/products/presentation/widgets/widgets_of_product_detail/empty_state.dart';

BoxDecoration _cardDeco({double radius = 16, Color? borderColor}) =>
    BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? AppColors.containrGrey),
      boxShadow: const [
        BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
      ],
    );

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
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity);
      } catch (_) {
        return const Center(
            child:
                Icon(Icons.broken_image, size: 48, color: AppColors.greyColor));
      }
    }
    return CustomCachedNetworkImage(imageUrl: src, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: AppColors.containerGrey,
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Product Details',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightBlack)),
                      Row(
                        children: [
                          PDActionChip(
                            label: 'Edit',
                            icon: Icons.edit_outlined,
                            color: AppColors.blue,
                            onTap: () {
                              final id = p.id ?? '';
                              context.go(
                                  '/products/productAdd?isEditing=true&productId=$id');
                            },
                          ),
                          const Gap(8),
                          PDActionChip(
                            label: 'Delete',
                            icon: Icons.delete_outline_rounded,
                            color: AppColors.buttonRed,
                            onTap: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
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
                                        child: Text('Delete',
                                            style: TextStyle(
                                                color: AppColors.buttonRed))),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                toastification.show(
                                  title: const Text('Deleted'),
                                  description: const Text('Product deleted'),
                                  backgroundColor: AppColors.buttonRed,
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Gap(8),
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Back'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Gap(20),

                  Container(
                    height: 260,
                    decoration: _cardDeco(),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: p.images.isEmpty ? 1 : p.images.length,
                          onPageChanged: (i) => setState(() => _page = i),
                          itemBuilder: (context, index) {
                            if (p.images.isEmpty) {
                              return Container(
                                color: AppColors.containerGrey,
                                child: const Center(
                                    child: Icon(Icons.image_outlined,
                                        size: 64, color: AppColors.greyColor)),
                              );
                            }
                            return Container(
                              color: AppColors.containerGrey,
                              child: Center(
                                  child: _buildImageWidget(p.images[index])),
                            );
                          },
                        ),
                        if (p.images.isNotEmpty)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(p.images.length, (i) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  height: 6,
                                  width: _page == i ? 22 : 7,
                                  decoration: BoxDecoration(
                                    color: _page == i
                                        ? AppColors.blue
                                        : AppColors.containrGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Gap(20),

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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightBlack)),
                            const Gap(6),
                            Text(p.shortNote,
                                style: const TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 13,
                                    height: 1.5)),
                            const Gap(12),

                            // Badges
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                PDBadge(
                                  label: '★  ${p.rating.toStringAsFixed(1)}',
                                  textColor: AppColors.yellow,
                                  bgColor: const Color(0xFFFFF8E7),
                                  borderColor: const Color(0xFFFDE68A),
                                ),
                                if (p.isHot)
                                  PDBadge(
                                    label: '🔥  HOT',
                                    textColor: AppColors.orang,
                                    bgColor: const Color(0xFFFFF0EB),
                                    borderColor: const Color(0xFFFFD0BB),
                                  ),
                              ],
                            ),

                            const Gap(14),

                            // Category + note card
                            Container(
                              decoration: _cardDeco(radius: 12),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CATEGORY',
                                      style: TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 10,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w600)),
                                  const Gap(6),
                                  if (p.categoryId.isEmpty)
                                    const Text('Not assigned',
                                        style: TextStyle(
                                            color: AppColors.lightBlack,
                                            fontWeight: FontWeight.w600))
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
                                        final name = cat.name.isNotEmpty
                                            ? cat.name
                                            : 'Uncategorized';
                                        return Text(name,
                                            style: const TextStyle(
                                                color: AppColors.lightBlack,
                                                fontWeight: FontWeight.w600));
                                      },
                                    ),
                                  if (p.additionalNote.isNotEmpty) ...[
                                    const Gap(12),
                                    const Divider(
                                        color: AppColors.containrGrey,
                                        height: 1),
                                    const Gap(12),
                                    const Text('ADDITIONAL NOTE',
                                        style: TextStyle(
                                            color: AppColors.greyColor,
                                            fontSize: 10,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w600)),
                                    const Gap(6),
                                    Text(p.additionalNote,
                                        style: const TextStyle(
                                            color: AppColors.greyColor,
                                            fontSize: 13,
                                            height: 1.5)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            PDStatCard(
                                label: 'Images',
                                value: '${p.images.length}',
                                icon: Icons.photo_library_outlined,
                                color: AppColors.blue),
                            const Gap(12),
                            PDStatCard(
                                label: 'Variants',
                                value: '${p.variants.length}',
                                icon: Icons.tune_rounded,
                                color: AppColors.greenColor),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Gap(24),
  
                  PDSectionHeader(label: 'Variants', count: p.variants.length),
                  const Gap(10),
                  if (p.variants.isEmpty)
                    pdEmptyState('No variants available')
                  else
                    Column(
                      children: p.variants
                          .map((v) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: _cardDeco(radius: 12),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  title: Text('${v.unit} · ${v.variant}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1F36),
                                          fontSize: 14)),
                                  subtitle: Text(
                                      'MRP ₹${v.mrp.toStringAsFixed(2)}   ·   Sell ₹${v.sellingPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 12)),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: v.stock > 0
                                          ? const Color(0xFFECFDF5)
                                          : const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: v.stock > 0
                                              ? const Color(0xFFBBF7D0)
                                              : const Color(0xFFFECACA)),
                                    ),
                                    child: Text('Stock ${v.stock}',
                                        style: TextStyle(
                                            color: v.stock > 0
                                                ? AppColors.greenColor
                                                : AppColors.buttonRed,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                  const Gap(24),

                  PDSectionHeader(label: 'Details', count: p.details.length),
                  const Gap(10),
                  if (p.details.isEmpty)
                    pdEmptyState('No details available')
                  else
                    Column(
                      children: p.details
                          .map((d) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: _cardDeco(radius: 12),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.heading,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1F36),
                                            fontSize: 14)),
                                    const Gap(8),
                                    Text(d.content,
                                        style: const TextStyle(
                                            color: AppColors.greyColor,
                                            fontSize: 13,
                                            height: 1.55)),
                                  ],
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

