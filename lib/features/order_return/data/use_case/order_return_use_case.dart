import 'package:e_com_admin/features/order_return/domain/repository/order_return_repository.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderReturnUseCase {
  final OrderReturnRepository repository;

  OrderReturnUseCase(this.repository);

  Stream<List<OrderModel>> getOrders() {
    return repository.getOrders();
  }

  Stream<List<OrderModel>> getOrdersByUser(String userId) {
    return repository.getOrdersByUser(userId);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) {
    return repository.updateOrderStatus(orderId: orderId, status: status);
  }

  Future<void> updateReturnStatus({
    required String orderId,
    required ReturnStatus status,
    String? adminNotes,
  }) {
    return repository.updateReturnStatus(
      orderId: orderId,
      status: status,
      adminNotes: adminNotes,
    );
  }
}
