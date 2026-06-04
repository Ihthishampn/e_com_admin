import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String? variantId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      variantId: map['variantId'],
      quantity: (map['quantity'] ?? 0).toInt(),
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
      'price': price,
    };
  }
}

class OrderModel {
  final String? id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final DateTime? createdAt;

  OrderModel({
    this.id,
    required this.userId,
    this.items = const [],
    this.totalAmount = 0.0,
    this.status = 'pending',
    this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: (map['items'] as List? ?? [])
          .map((i) => OrderItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

class ReturnModel {
  final String? id;
  final String orderId;
  final String userId;
  final List<OrderItem> items;
  final String reason;
  final String status;
  final DateTime? createdAt;

  ReturnModel({
    this.id,
    required this.orderId,
    required this.userId,
    this.items = const [],
    this.reason = '',
    this.status = 'requested',
    this.createdAt,
  });

  factory ReturnModel.fromMap(Map<String, dynamic> map, String id) {
    return ReturnModel(
      id: id,
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List? ?? [])
          .map((i) => OrderItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      reason: map['reason'] ?? '',
      status: map['status'] ?? 'requested',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'orderId': orderId,
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'reason': reason,
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
