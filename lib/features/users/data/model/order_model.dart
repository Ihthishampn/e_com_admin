import 'package:e_com_admin/features/users/data/model/return_refund_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userPhone;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final double amount;
  final List<OrderItemSummary> items;
  final ShippingAddress shippingAddress;
  final ReturnDetails? returnDetails;

  const OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.date,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.amount,
    required this.items,
    required this.shippingAddress,
    this.returnDetails,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, [String id = '']) {
    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {
          // try parsing as milliseconds string
          final ms = int.tryParse(v);
          if (ms != null) return DateTime.fromMillisecondsSinceEpoch(ms);
        }
      }
      return DateTime.now();
    }

    return OrderModel(
      orderId: id.isNotEmpty ? id : (map['orderId'] ?? ''),
      userId: map['userId'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      date: parseDate(map['date']),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (map['paymentMethod'] as String? ?? '').toLowerCase(),
        orElse: () => PaymentMethod.cod,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (map['paymentStatus'] as String? ?? '').toLowerCase(),
        orElse: () => PaymentStatus.pending,
      ),
      orderStatus: OrderStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (map['orderStatus'] as String? ?? '').toLowerCase(),
        orElse: () => OrderStatus.pending,
      ),
      amount: (map['amount'] ?? 0).toDouble(),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemSummary.fromMap(e))
          .toList(),
      shippingAddress: ShippingAddress.fromMap(map['shippingAddress'] ?? {}),
      returnDetails: map['returnDetails'] != null
          ? ReturnDetails.fromMap(map['returnDetails'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'orderNumber': orderNumber,
      'userPhone': userPhone,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'orderStatus': orderStatus.name,
      'amount': amount,
      'items': items.map((e) => e.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      if (returnDetails != null) 'returnDetails': returnDetails!.toMap(),
    };
  }
}

class OrderItemSummary {
  final String productId;
  final String productName;
  final String variantName;
  final int quantity;
  final double price;
  final String imageUrl;

  const OrderItemSummary({
    required this.productId,
    required this.productName,
    required this.variantName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItemSummary.fromMap(Map<String, dynamic> map) {
    return OrderItemSummary(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      variantName: map['variantName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'variantName': variantName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

class ShippingAddress {
  final String name;
  final String street;
  final String city;
  final String state;
  final String pincode;

  const ShippingAddress({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      name: map['name'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }
}

enum PaymentMethod {
  cod,
  upi,
  card,
  netBanking,
  wallet,
}

enum OrderStatus {
  pending,
  accepted,
  packed,
  shipped,
  delivered,
  cancelled,
  rejected,
  returned
}

enum PaymentStatus { pending, paid, failed, refunded }

enum ReturnStatus { none, requested, approved, rejected, processed }
