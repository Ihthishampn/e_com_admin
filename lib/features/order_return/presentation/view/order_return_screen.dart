import 'package:e_com_admin/features/order_return/presentation/provider/order_return_provider.dart';
import 'package:e_com_admin/general/utils/enums/app_state.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:e_com_admin/general/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../widgets/status_filters.dart';
import '../widgets/section_title.dart';
import '../widgets/order_card.dart';
import '../widgets/return_card.dart';

class OrderReturnScreen extends StatelessWidget {
  const OrderReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderReturnProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Order Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const StatusFilters(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 400,
                        child: CustomSearchField(
                          onChanged: (value) {
                            provider.search(value ?? '');
                          },
                          hintText: 'search here',
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildBody(provider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(OrderReturnProvider provider) {
    if (provider.state == AppState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state == AppState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const Gap(16),
            Text(
              provider.error ?? 'An error occurred while fetching orders.',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SectionTitle(label: 'Orders'),
        const Gap(16),
        if (provider.filteredOrders.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ...provider.filteredOrders.map((order) => OrderCard(order: order)),
        const Gap(32),
        const SectionTitle(label: 'Return Requests'),
        const Gap(16),
        if (provider.returnRequests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'No return requests found',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ...provider.returnRequests.map((order) => ReturnCard(order: order)),
      ],
    );
  }
}
