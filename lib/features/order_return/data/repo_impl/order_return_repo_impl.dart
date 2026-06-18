import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/features/order_return/domain/repository/order_return_repository.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderReturnRepository)
class OrderReturnRepoImpl implements OrderReturnRepository {
  final FirebaseFirestore _firestore;

  OrderReturnRepoImpl(this._firestore);

  @override
  Stream<List<OrderModel>> getOrders() {
    return _firestore
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Stream<List<OrderModel>> getOrdersByUser(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'orderStatus': status.name,
    });
  }

  @override
  Future<void> updateReturnStatus({
    required String orderId,
    required ReturnStatus status,
    String? adminNotes,
  }) async {
    final Map<String, dynamic> updates = {
      'returnDetails.status': status.name,
    };
    if (adminNotes != null) {
      updates['returnDetails.adminNotes'] = adminNotes;
    }
    await _firestore.collection('orders').doc(orderId).update(updates);
  }
}
