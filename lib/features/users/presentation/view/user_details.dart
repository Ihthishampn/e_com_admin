import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/widgets_of_user_detail/user_info_card.dart';
import '../widgets/widgets_of_user_detail/stat_card.dart';
import '../widgets/widgets_of_user_detail/tab_button_selector.dart';
import '../widgets/widgets_of_user_detail/orders_table.dart';
import '../widgets/widgets_of_user_detail/returns_table.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int _selectedTabIndex = 0; 

  // Static UI Mock Data  
  final Map<String, String> _mockUser = {
    'id': 'USR-89421',
    'initial': 'JD',
    'displayName': 'John Doe',
    'phoneNumber': '+91 98765 43210',
  };

  final List<List<String>> _mockOrders = [
    ['02/06/2026', 'ORD-2026-9482', '3', 'UPI', '1,250.00', 'DELIVERED'],
    ['28/05/2026', 'ORD-2026-9110', '1', 'NetBanking', '450.00', 'DELIVERED'],
    ['15/05/2026', 'ORD-2026-8841', '2', 'COD', '890.00', 'CANCELLED'],
  ];

  final List<List<String>> _mockReturns = [
    [
      '29/05/2026',
      'ORD-2026-9110',
      'Item defective or crushed packaging',
      'RETURNED'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Column(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: const Center(
              child: Text(
                'Admin Header Placeholder',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top action bar
        Row(
          children: [
            const Text(
              'User Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search here",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF0061D1)),
                  ),
                ),
              ),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0061D1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
              child: const Text('Back',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const Gap(24),

        // Main white card container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoCard(
                userId: _mockUser['id']!,
                initial: _mockUser['initial']!,
                displayName: _mockUser['displayName']!,
                phoneNumber: _mockUser['phoneNumber']!,
              ),
              const Gap(32),

              // Overview Status Stats
              Row(
                children: [
                  StatCard(
                      label: 'Total Orders',
                      value: '3',
                      color: const Color(0xFFCDE4FF)),
                  const Gap(16),
                  StatCard(
                      label: 'Total Amount',
                      value: '₹2,590.00',
                      color: const Color(0xFFE6D5FF)),
                  const Gap(16),
                  StatCard(
                      label: 'Return Ratio',
                      value: '33.3%',
                      color: const Color(0xFFD9D9D9)),
                ],
              ),
              const Gap(32),

              // Interactive Tab Layout
              TabButtonSelector(
                selectedTabIndex: _selectedTabIndex,
                onTabChanged: (index) =>
                    setState(() => _selectedTabIndex = index),
              ),
              const Gap(24),

              // Contextual list viewing toggle
              _selectedTabIndex == 0
                  ? OrdersTable(mockOrders: _mockOrders)
                  : ReturnsTable(mockReturns: _mockReturns),
            ],
          ),
        ),
        const Gap(40),
      ],
    );
  }
}
