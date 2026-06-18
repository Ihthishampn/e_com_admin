import 'package:e_com_admin/features/order_return/presentation/provider/order_return_provider.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'info_row.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.packed:
        return Colors.indigo;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final otherItemsCount = order.items.length - 1;
    final totalQty =
        order.items.fold<int>(0, (sum, item) => sum + item.quantity);

    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Number: ${order.orderNumber}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderStatus.name.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order.orderStatus),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: firstItem != null && firstItem.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                firstItem.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                  child: Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.image,
                                  size: 40, color: Colors.grey),
                            ),
                    ),
                    if (otherItemsCount > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+$otherItemsCount Products',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem?.productName ?? 'No items in order',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (firstItem != null &&
                          firstItem.variantName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Variant: ${firstItem.variantName}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '₹ ${order.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quantity: $totalQty',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(
                          label: 'Payment Method',
                          value: order.paymentMethod.name.toUpperCase()),
                      const SizedBox(height: 8),
                      InfoRow(label: 'Phone Number', value: order.userPhone),
                      const SizedBox(height: 8),
                      InfoRow(label: 'Customer', value: order.userName),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.shippingAddress.name,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Text(
                        order.shippingAddress.street,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Text(
                        '${order.shippingAddress.city}, ${order.shippingAddress.state}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Text(
                        order.shippingAddress.pincode,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(order.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Row(
                  children: [
                    if (!(order.orderStatus == OrderStatus.rejected ||
                        order.orderStatus == OrderStatus.cancelled ||
                        order.orderStatus == OrderStatus.delivered ||
                        order.orderStatus == OrderStatus.returned))
                      PopupMenuButton<OrderStatus>(
                        initialValue: order.orderStatus,
                        onSelected: (OrderStatus newStatus) async {
                          try {
                            await context
                                .read<OrderReturnProvider>()
                                .updateOrderStatus(
                                  orderId: order.orderId,
                                  status: newStatus,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Order status updated to ${newStatus.name.toUpperCase()}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update status: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final allowed = [
                            OrderStatus.pending,
                            OrderStatus.accepted,
                            OrderStatus.packed,
                            OrderStatus.shipped,
                            OrderStatus.delivered,
                          ];
                          return allowed.map((OrderStatus val) {
                            return PopupMenuItem<OrderStatus>(
                              value: val,
                              child: Text(val.name.toUpperCase()),
                            );
                          }).toList();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Update Status',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    if (order.orderStatus == OrderStatus.pending) ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () async {
                          try {
                            await context
                                .read<OrderReturnProvider>()
                                .updateOrderStatus(
                                  orderId: order.orderId,
                                  status: OrderStatus.rejected,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order rejected'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to reject order: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ]),
        ));
  }
}
