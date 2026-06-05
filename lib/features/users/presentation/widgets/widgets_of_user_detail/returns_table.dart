import 'package:flutter/material.dart';

class ReturnsTable extends StatelessWidget {
  final List<List<String>> mockReturns;

  const ReturnsTable({
    Key? key,
    required this.mockReturns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tableHeader(['Date', 'Order Number', 'Reason', 'Status']),
        if (mockReturns.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No return records found'),
          )
        else
          ...mockReturns.map((ret) => _tableRow(ret)),
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
}
