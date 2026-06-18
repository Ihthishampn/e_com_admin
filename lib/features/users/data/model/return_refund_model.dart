import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReturnAndRefundModel {
  final DateTime date;
  final String orderNumber;
  final String reason;
  final String status;

  const ReturnAndRefundModel({
    required this.date,
    required this.orderNumber,
    required this.reason,
    required this.status,
  });

  factory ReturnAndRefundModel.fromMap(Map<String, dynamic> map) {
    DateTime _parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {
          final ms = int.tryParse(v);
          if (ms != null) return DateTime.fromMillisecondsSinceEpoch(ms);
        }
      }
      return DateTime.now();
    }

    return ReturnAndRefundModel(
      date: _parseDate(map['date']),
      orderNumber: map['orderNumber'] ?? '',
      reason: map['reason'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'orderNumber': orderNumber,
      'reason': reason,
      'status': status,
    };
  }
}

class ReturnDetails {
  final String reason;
  final ReturnStatus status;
  final DateTime requestedAt;
  final String? adminNotes;

  const ReturnDetails({
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.adminNotes,
  });

  factory ReturnDetails.fromMap(Map<String, dynamic> map) {
    DateTime _parseReq(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {
          final ms = int.tryParse(v);
          if (ms != null) return DateTime.fromMillisecondsSinceEpoch(ms);
        }
      }
      return DateTime.now();
    }

    return ReturnDetails(
      reason: map['reason'] ?? '',
      status: ReturnStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReturnStatus.none,
      ),
      requestedAt: _parseReq(map['requestedAt']),
      adminNotes: map['adminNotes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      if (adminNotes != null) 'adminNotes': adminNotes,
    };
  }
}
