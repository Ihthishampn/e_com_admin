import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart';
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
  String? _selectedCategoryId; // null means show all

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();

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
                          HeaderButton(text: "Unit Settings"),
                          Gap(12),
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
                        final cats = snap.data ?? [];
                        // Build chips: All + dynamic categories
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedCategoryId = null),
                                child: filter.CategoryFilterChip(
                                  label: 'All',
                                  selected: _selectedCategoryId == null,
                                ),
                              ),
                              ...cats.map((c) {
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedCategoryId = c.id),
                                  child: filter.CategoryFilterChip(
                                    label: c.name,
                                    selected: _selectedCategoryId == c.id,
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
                      stream: _selectedCategoryId == null
                          ? provider.handleProductFetch()
                          : provider
                              .handleProductsByCategory(_selectedCategoryId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }

                        final products = snapshot.data ?? [];

                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products added',
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
}
