import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
import 'dart:developer';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';

import '../../data/model/product_model.dart';
import '../provider/product_provider.dart';
import '../widgets/widgets_of_product_screen/filter_chip.dart' as filter;
import '../widgets/widgets_of_product_screen/header_button.dart';
import '../widgets/widgets_of_product_screen/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          HeaderButton(text: "Add New Product"),
                        ],
                      ),
                    ],
                  ),

                  const Gap(24),

                  /// Filters (categories)
                  SizedBox(
                    height: 46,
                    child: StreamBuilder<List<CategoryModel>>(
                      stream: context
                          .read<CategoryProvider>()
                          .handleCategoryFetch(),
                      builder: (context, snap) {
                        if (snap.hasError) {
                          // ignore: avoid_print
                          print('Category chips stream error: ${snap.error}');
                          log('Category chips stream error', error: snap.error);
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: []),
                          );
                        }
                        final cats = snap.data ?? [];
                        // Build chips: All + dynamic categories
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Clear any active search when selecting All
                                  _searchController.clear();
                                  provider.selectCategory(null);
                                },
                                child: filter.CategoryFilterChip(
                                  label: 'All',
                                  selected: provider.selectedCategoryId == null,
                                ),
                              ),
                              ...cats.map((c) {
                                return GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    provider.selectCategory(c.id);
                                  },
                                  child: filter.CategoryFilterChip(
                                    label: c.name,
                                    selected:
                                        provider.selectedCategoryId == c.id,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Gap(16),

                  /// Search
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        provider.updateSearchQuery(v);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Gap(24),

                  /// Product Grid
                  Expanded(
                    child: StreamBuilder<List<ProductModel>>(
                      initialData: provider.searchQuery.isEmpty &&
                              provider.selectedCategoryId == null
                          ? <ProductModel>[]
                          : null,
                      stream: provider.productsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          // ignore: avoid_print
                          print('Product stream error: ${snapshot.error}');
                          log('Product stream error', error: snapshot.error);
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }

                        final products = snapshot.data ?? [];

                        if (products.isEmpty) {
                          final query = provider.searchQuery.trim();
                          final message = query.isEmpty
                              ? (provider.selectedCategoryId == null
                                  ? 'No products added'
                                  : 'No products found for the selected category')
                              : 'No product found with your input';

                          return Center(
                            child: Text(
                              message,
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,

                            // FIXED HEIGHT
                            mainAxisExtent: 320,
                          ),
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: products[index],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
