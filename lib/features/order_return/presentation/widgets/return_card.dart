import 'package:e_com_admin/features/order_return/presentation/provider/order_return_provider.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ReturnCard extends StatelessWidget {
  final OrderModel order;

  const ReturnCard({
    super.key,
    required this.order,
  });

  Color _getStatusColor(ReturnStatus status) {
    switch (status) {
      case ReturnStatus.none:
        return Colors.grey;
      case ReturnStatus.requested:
        return Colors.orange;
      case ReturnStatus.approved:
        return Colors.green;
      case ReturnStatus.rejected:
        return Colors.red;
      case ReturnStatus.processed:
        return Colors.blue;
    }
  }

  void _showReturnDetailsDialog(BuildContext context) {
    final notesController =
        TextEditingController(text: order.returnDetails?.adminNotes ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Return Request: #${order.orderNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _detailRow('Customer', order.userName),
                  const Gap(8),
                  _detailRow('Phone', order.userPhone),
                  const Gap(8),
                  _detailRow(
                    'Requested On',
                    order.returnDetails != null
                        ? DateFormat('dd MMM yyyy, hh:mm a')
                            .format(order.returnDetails!.requestedAt)
                        : 'N/A',
                  ),
                  const Gap(8),
                  _detailRow(
                    'Current Status',
                    order.returnDetails?.status.name.toUpperCase() ?? 'N/A',
                    valueColor: _getStatusColor(
                        order.returnDetails?.status ?? ReturnStatus.none),
                  ),
                  const Gap(16),
                  const Text(
                    'Reason for Return',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Gap(6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      order.returnDetails?.reason ?? 'No reason provided',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'Admin Notes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Gap(6),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter internal notes here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<OrderReturnProvider>().updateReturnStatus(
                        orderId: order.orderId,
                        status: ReturnStatus.rejected,
                        adminNotes: notesController.text.trim(),
                      );
                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Return request rejected'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  toastification.show(title: Text(('Error: $e')));
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Reject', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<OrderReturnProvider>().updateReturnStatus(
                        orderId: order.orderId,
                        status: ReturnStatus.approved,
                        adminNotes: notesController.text.trim(),
                      );
                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Return request approved'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child:
                  const Text('Approve', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<OrderReturnProvider>().updateReturnStatus(
                        orderId: order.orderId,
                        status: ReturnStatus.processed,
                        adminNotes: notesController.text.trim(),
                      );
                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Return marked as processed'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child:
                  const Text('Process', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = order.returnDetails?.status ?? ReturnStatus.none;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment_return_outlined,
              color: _getStatusColor(status),
            ),
          ),
          title: Text(
            'Order #${order.orderNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            order.returnDetails?.reason ?? 'No reason provided',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.name.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          onTap: () => _showReturnDetailsDialog(context),
        ),
      ),
    );
  }
}
