
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:e_com_admin/features/users/data/model/return_refund_model.dart';

class UserModel {
  final String id;
  final String name;
  final String number;
  final String imageUrl;

  final int totalOrders;
  final double totalAmount;
  final double returnRatio;

  final List<OrderModel> orders;
  final List<ReturnAndRefundModel> refunds;

  const UserModel({
    required this.id,
    required this.name,
    required this.number,
    this.imageUrl = '',
    this.totalOrders = 0,
    this.totalAmount = 0,
    this.returnRatio = 0,
    this.orders = const [],
    this.refunds = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      number: map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      totalOrders: map['totalOrders'] ?? 0,
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      returnRatio: (map['returnRatio'] ?? 0).toDouble(),
      orders: (map['orders'] as List<dynamic>? ?? [])
          .map((e) => OrderModel.fromMap(e))
          .toList(),
      refunds: (map['refunds'] as List<dynamic>? ?? [])
          .map((e) => ReturnAndRefundModel.fromMap(e))
          .toList(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? number,
    String? imageUrl,
    int? totalOrders,
    double? totalAmount,
    double? returnRatio,
    List<OrderModel>? orders,
    List<ReturnAndRefundModel>? refunds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      imageUrl: imageUrl ?? this.imageUrl,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      returnRatio: returnRatio ?? this.returnRatio,
      orders: orders ?? this.orders,
      refunds: refunds ?? this.refunds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': number,
      'imageUrl': imageUrl,
      'totalOrders': totalOrders,
      'totalAmount': totalAmount,
      'returnRatio': returnRatio,
      'orders': orders.map((e) => e.toMap()).toList(),
      'refunds': refunds.map((e) => e.toMap()).toList(),
    };
  }
}