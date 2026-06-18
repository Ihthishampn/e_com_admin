import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:e_com_admin/features/users/presentation/provider/user_provider.dart';
import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/data/model/order_model.dart';
import 'package:e_com_admin/general/core/injection/injection.dart';
import 'package:e_com_admin/features/order_return/data/use_case/order_return_use_case.dart';
import '../widgets/widgets_of_user_detail/user_info_card.dart';
import '../widgets/widgets_of_user_detail/stat_card.dart';
import '../widgets/widgets_of_user_detail/tab_button_selector.dart';
import '../widgets/widgets_of_user_detail/orders_table.dart';
import '../widgets/widgets_of_user_detail/returns_table.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int _selectedTabIndex = 0;
  late Future<UserModel?> _userFuture;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;
  List<OrderModel> _ordersCache = [];
  bool _ordersLoading = true;
  String? _subscribedUserId;

  @override
  void initState() {
    super.initState();
    _userFuture = context.read<UserProvider>().fetchUserById(widget.userId);
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  log('UserDetailsScreen.fetchUserById error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final user = snapshot.data;
                if (user == null) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: const [
                          SizedBox(height: 48),
                          Icon(Icons.person_off, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('User not found',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                // Subscribe once to orders for this user and cache latest data to avoid
                // re-subscribing/rebuilding when switching tabs (prevents blinking).
                final orderUseCase = getIt<OrderReturnUseCase>();
                if (_subscribedUserId != user.id) {
                  // cancel previous
                  _ordersSubscription?.cancel();
                  _ordersSubscription =
                      orderUseCase.getOrdersByUser(user.id).listen((orders) {
                    if (!mounted) return;
                    setState(() {
                      _ordersCache = orders;
                      _ordersLoading = false;
                    });
                  }, onError: (err) {
                    log('UserDetailsScreen.orders subscription error: $err');
                    if (!mounted) return;
                    setState(() {
                      _ordersLoading = false;
                    });
                  });
                  _subscribedUserId = user.id;
                  _ordersLoading = true;
                  _ordersCache = [];
                }

                final orders = _ordersCache;
                if (_ordersLoading && orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final totalOrders = orders.length;
                final totalAmount =
                    orders.fold<double>(0.0, (p, o) => p + (o.amount));
                final returnCount = orders
                    .where((o) =>
                        o.returnDetails != null &&
                        o.returnDetails!.status != ReturnStatus.none)
                    .length;
                final returnRatio =
                    totalOrders > 0 ? (returnCount / totalOrders) * 100.0 : 0.0;

                final orderRows = orders
                    .map((o) => [
                          '${o.date.day.toString().padLeft(2, '0')}/${o.date.month.toString().padLeft(2, '0')}/${o.date.year}',
                          o.orderNumber,
                          o.items.length.toString(),
                          o.paymentMethod.name.toUpperCase(),
                          o.amount.toStringAsFixed(2),
                          o.orderStatus.name.toUpperCase(),
                        ])
                    .toList()
                    .cast<List<String>>();

                final refunds = orders
                    .where((o) =>
                        o.returnDetails != null &&
                        o.returnDetails!.status != ReturnStatus.none)
                    .map((r) => [
                          '${r.returnDetails!.requestedAt.day.toString().padLeft(2, '0')}/${r.returnDetails!.requestedAt.month.toString().padLeft(2, '0')}/${r.returnDetails!.requestedAt.year}',
                          r.orderNumber,
                          r.returnDetails!.reason,
                          r.returnDetails!.status.name.toUpperCase(),
                        ])
                    .toList()
                    .cast<List<String>>();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Back"),
                          ),
                          Gap(20),
                        ],
                      ),
                      UserInfoCard(
                        userId: user.id,
                        initial: user.name
                            .split(' ')
                            .where((s) => s.isNotEmpty)
                            .map((s) => s[0])
                            .take(2)
                            .join()
                            .toUpperCase(),
                        displayName: user.name,
                        phoneNumber: user.number,
                      ),
                      const Gap(24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StatCard(
                                  label: 'Total Orders',
                                  value: totalOrders.toString(),
                                  color: const Color(0xFFCDE4FF)),
                              const Gap(16),
                              StatCard(
                                  label: 'Total Amount',
                                  value: '₹${totalAmount.toStringAsFixed(2)}',
                                  color: const Color(0xFFE6D5FF)),
                              const Gap(16),
                              StatCard(
                                  label: 'Return Ratio',
                                  value: '${returnRatio.toStringAsFixed(1)}%',
                                  color: const Color(0xFFD9D9D9)),
                            ],
                          ),
                          const Gap(32),
                          TabButtonSelector(
                            selectedTabIndex: _selectedTabIndex,
                            onTabChanged: (index) =>
                                setState(() => _selectedTabIndex = index),
                          ),
                          const Gap(24),
                          _selectedTabIndex == 0
                              ? OrdersTable(mockOrders: orderRows)
                              : ReturnsTable(mockReturns: refunds),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
