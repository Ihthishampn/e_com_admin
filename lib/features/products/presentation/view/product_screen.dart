import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../../data/model/product_model.dart';
import '../provider/product_provider.dart';
import '../widgets/widgets_of_product_screen/header_button.dart';
import '../widgets/widgets_of_product_screen/filter_chip.dart' as filter;
import '../widgets/widgets_of_product_screen/product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

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
                          const HeaderButton(text: "Unit Settings"),
                          const Gap(12),
                          const HeaderButton(text: "Add New Product"),
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
                        filter.CategoryFilterChip(
                            label: "All(0)", selected: true),
                        filter.CategoryFilterChip(label: "Category 1(0)"),
                        filter.CategoryFilterChip(label: "Category 2(0)"),
                        filter.CategoryFilterChip(label: "Category 3(0)"),
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
                    child: StreamBuilder<List<ProductModel>>(
                      stream: provider.handleProductFetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }

                        final products = snapshot.data ?? [];
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
                            return ProductCard(product: p);
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
