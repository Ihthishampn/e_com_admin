import 'package:e_com_admin/features/users/data/model/order_model.dart';

abstract class OrderReturnRepository {
  Stream<List<OrderModel>> getOrders();
  Stream<List<OrderModel>> getOrdersByUser(String userId);
  Future<void> updateOrderStatus(
      {required String orderId, required OrderStatus status});
  Future<void> updateReturnStatus(
      {required String orderId,
      required ReturnStatus status,
      String? adminNotes});
}
