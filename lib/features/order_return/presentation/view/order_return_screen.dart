import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:e_com_admin/general/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/status_filters.dart';
import '../widgets/section_title.dart';
import '../widgets/order_card.dart';
import '../widgets/return_card.dart';

class OrderReturnScreen extends StatelessWidget {
  const OrderReturnScreen({super.key});

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
                          onChanged: (value) {},
                          hintText: 'search here',
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: const [
                        SectionTitle(label: 'Orders'),
                        Gap(16),
                        OrderCard(),
                        Gap(16),
                        OrderCard(),
                        Gap(32),
                        SectionTitle(label: 'Return Requests'),
                        Gap(16),
                        ReturnCard(),
                      ],
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
