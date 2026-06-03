import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int _selectedTabIndex = 0; // 0 for Orders, 1 for Refund & Return

  // --- Static UI Mock Data ---
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
    ['29/05/2026', 'ORD-2026-9110', 'Item defective or crushed packaging', 'RETURNED'],
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
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                // Back navigation mockup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0061D1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
              child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
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
              Text('ID: ${_mockUser['id']}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              const Gap(16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF2D2D2D),
                    child: Text(_mockUser['initial']!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _userField('Name', _mockUser['displayName']!),
                      const Gap(8),
                      _userField('Phone Number', _mockUser['phoneNumber']!),
                    ],
                  ),
                ],
              ),
              const Gap(32),

              // Overview Status Stats
              Row(
                children: [
                  _statCard('Total Orders', '3', const Color(0xFFCDE4FF)),
                  const Gap(16),
                  _statCard('Total Amount', '₹2,590.00', const Color(0xFFE6D5FF)),
                  const Gap(16),
                  _statCard('Return Ratio', '33.3%', const Color(0xFFD9D9D9)),
                ],
              ),
              const Gap(32),

              // Interactive Tab Layout
              Row(
                children: [
                  _tabButton('Orders', 0),
                  const Gap(8),
                  _tabButton('Refund & Return', 1),
                ],
              ),
              const Gap(24),

              // Contextual list viewing toggle
              _selectedTabIndex == 0
                  ? _buildOrdersTable()
                  : _buildReturnsTable(),
            ],
          ),
        ),
        const Gap(40),
      ],
    );
  }

  Widget _userField(String label, String value) {
    return Row(
      children: [
        SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        const Text(':  ', style: TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Gap(4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersTable() {
    return Column(
      children: [
        _tableHeader([
          'Date',
          'Order Number',
          'No. Of Products',
          'Pay. Method',
          'Amount',
          'Status'
        ]),
        ..._mockOrders.map((order) => _tableRow(order)),
        _tableTotalRow('2,590.00'),
      ],
    );
  }

  Widget _buildReturnsTable() {
    return Column(
      children: [
        _tableHeader(['Date', 'Order Number', 'Reason', 'Status']),
        if (_mockReturns.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No return records found'),
          )
        else
          ..._mockReturns.map((ret) => _tableRow(ret)),
      ],
    );
  }

  Widget _tableHeader(List<String> titles) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: titles
            .map((t) => Expanded(
                child: Text(t,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black54))))
            .toList(),
      ),
    );
  }

  Widget _tableRow(List<String> values) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: values.asMap().entries.map((entry) {
          int idx = entry.key;
          String val = entry.value;
          Color textColor = Colors.black87;

          // Check for tailing status highlights
          if (idx == values.length - 1) {
            if (val == 'COMPLETED' || val == 'DELIVERED' || val == 'RETURNED') {
              textColor = Colors.green;
            }
            if (val == 'CANCELLED' || val == 'REJECTED') {
              textColor = Colors.red;
            }
          }
          return Expanded(
            child: Text(
              val,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: idx == values.length - 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tableTotalRow(String total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: const Color(0xFFF1F2F2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Total: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text('₹$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}