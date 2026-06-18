import 'dart:async';
import 'package:e_com_admin/features/order_return/data/use_case/order_return_use_case.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:e_com_admin/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderReturnProvider with ChangeNotifier {
  final OrderReturnUseCase _useCase;
  StreamSubscription<List<OrderModel>>? _subscription;

  List<OrderModel> _allOrders = [];
  String _selectedStatusFilter = 'ALL';
  String _searchQuery = '';

  AppState state = AppState.initial;
  String? error;

  OrderReturnProvider(this._useCase) {
    _init();
  }

  void _init() {
    state = AppState.loading;
    _subscription = _useCase.getOrders().listen(
      (orders) {
        _allOrders = orders;
        state = AppState.success;
        _applyFilters();
      },
      onError: (err) {
        error = err.toString();
        state = AppState.error;
        notifyListeners();
      },
    );
  }

  String get selectedStatusFilter => _selectedStatusFilter;
  String get searchQuery => _searchQuery;

  List<OrderModel> _filteredOrders = [];
  List<OrderModel> _returnRequests = [];

  List<OrderModel> get filteredOrders => _filteredOrders;
  List<OrderModel> get returnRequests => _returnRequests;

  void changeStatusFilter(String filter) {
    _selectedStatusFilter = filter;
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    List<OrderModel> tempOrders = _allOrders;

    if (_selectedStatusFilter != 'ALL') {
      tempOrders = tempOrders.where((order) {
        return order.orderStatus.name.toUpperCase() == _selectedStatusFilter;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tempOrders = tempOrders.where((order) {
        return order.orderNumber.toLowerCase().contains(q) ||
            order.userName.toLowerCase().contains(q) ||
            order.userPhone.toLowerCase().contains(q);
      }).toList();
    }

    _filteredOrders = tempOrders;

    // Filter return requests from all orders
    _returnRequests = _allOrders.where((order) {
      return order.returnDetails != null &&
          order.returnDetails!.status != ReturnStatus.none;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      _returnRequests = _returnRequests.where((order) {
        return order.orderNumber.toLowerCase().contains(q) ||
            order.userName.toLowerCase().contains(q) ||
            order.userPhone.toLowerCase().contains(q) ||
            order.returnDetails!.reason.toLowerCase().contains(q);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await _useCase.updateOrderStatus(orderId: orderId, status: status);
      // After successful update, set the status filter to the updated status
      _selectedStatusFilter = status.name.toUpperCase();
      _applyFilters();
    } catch (err) {
      error = err.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateReturnStatus({
    required String orderId,
    required ReturnStatus status,
    String? adminNotes,
  }) async {
    try {
      await _useCase.updateReturnStatus(
        orderId: orderId,
        status: status,
        adminNotes: adminNotes,
      );
    } catch (err) {
      error = err.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
