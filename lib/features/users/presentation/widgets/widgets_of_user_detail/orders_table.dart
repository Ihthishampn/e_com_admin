import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersTable extends StatelessWidget {
  final List<List<String>> mockOrders;

  const OrdersTable({
    super.key,
    required this.mockOrders,
  });

  @override
  Widget build(BuildContext context) {
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
        if (mockOrders.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No orders found'),
          )
        else ...[
          ...mockOrders.map((order) => _tableRow(order)),
          _tableTotalRow(_computeTotal(mockOrders)),
        ],
      ],
    );
  }

  String _computeTotal(List<List<String>> orders) {
    double total = 0.0;
    for (final order in orders) {
      if (order.length > 4) {
        final raw = order[4].replaceAll(',', '').replaceAll('₹', '').trim();
        total += double.tryParse(raw) ?? 0.0;
      }
    }
    // Format with currency symbol and two decimals
    final fmt = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    return fmt.format(total);
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
                    child: Text(
                  t,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                )))
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

          // Check for trailing status highlights
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
                fontWeight: idx == values.length - 1
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tableTotalRow(String totalWithSymbol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: const Color(0xFFF1F2F2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Total: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            totalWithSymbol,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
