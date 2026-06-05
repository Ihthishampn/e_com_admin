import 'package:e_com_admin/features/categories/presentation/view/category_products_screen.dart';
import 'package:e_com_admin/features/categories/presentation/view/category_screen.dart';
import 'package:e_com_admin/features/order_return/presentation/view/order_return_screen.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/products/presentation/view/add_product_screen.dart';
import 'package:e_com_admin/features/products/presentation/view/product_details_screen.dart';
import 'package:e_com_admin/features/products/presentation/view/product_screen.dart';
import 'package:e_com_admin/features/users/presentation/view/user_details.dart';
import 'package:e_com_admin/features/users/presentation/view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/sidebar/presentation/view/side_navigation_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteConfig {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/users',
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/users',
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return SideNavigationBar(child: child);
        },
        routes: [
          /// USERS
          GoRoute(
            path: '/users',
            pageBuilder: (context, state) =>
                _customPage(state, const UsersView()),
            routes: [
              GoRoute(
                path: 'userDetails',
                pageBuilder: (context, state) {
                  final userId = state.uri.queryParameters['userId'] ?? '';

                  return _customPage(
                    state,
                    UserDetailsScreen(userId: userId),
                  );
                },
              ),
            ],
          ),

          /// PRODUCTS
          GoRoute(
            path: '/products',
            pageBuilder: (context, state) =>
                _customPage(state, const ProductScreen()),
            routes: [
              GoRoute(
                path: 'productAdd',
                pageBuilder: (context, state) {
                  final isEditing =
                      state.uri.queryParameters['isEditing'] == 'true';

                  final productId =
                      state.uri.queryParameters['productId'] ?? '';

                  return _customPage(
                    state,
                    AddProductScreen(
                      isEditing: isEditing,
                      productId: productId,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'productDetails',
                pageBuilder: (context, state) {
                  final extra = state.extra;
                  if (extra is ProductModel) {
                    return _customPage(
                      state,
                      ProductDetailsScreen(product: extra),
                    );
                  }

                  // If navigation didn't provide a ProductModel (e.g. deep link),
                  // show a simple fallback page instead of throwing a runtime type error.
                  return _customPage(
                    state,
                    Scaffold(
                      appBar: AppBar(title: const Text('Product Details')),
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 56, color: Colors.red),
                            const SizedBox(height: 12),
                            const Text('No product data provided',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => context.go('/products'),
                              child: const Text('Back to Products'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          /// ORDERS
          GoRoute(
            path: '/orders',
            pageBuilder: (context, state) =>
                _customPage(state, const OrderReturnScreen()),
          ),

          /// CATEGORIES
          GoRoute(
            path: '/categories',
            pageBuilder: (context, state) =>
                _customPage(state, const CategoryScreen()),
            routes: [
              GoRoute(
                path: 'products',
                pageBuilder: (context, state) {
                  final categoryId = state.uri.queryParameters['id'] ?? '';

                  final categoryName = state.uri.queryParameters['name'] ?? '';
                  final categoryImage =
                      state.uri.queryParameters['image'] ?? '';

                  return _customPage(
                    state,
                    CategoryProductsScreen(
                      categoryId: categoryId,
                      categoryName: categoryName,
                      categoryImage: categoryImage,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static int calculateSelectedIndexFromPath(String path) {
    if (path.startsWith('/users')) return 0;
    if (path.startsWith('/products')) return 1;
    if (path.startsWith('/orders')) return 2;
    if (path.startsWith('/categories')) return 3;

    return 0;
  }

  static void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/users');
        break;

      case 1:
        context.go('/products');
        break;

      case 2:
        context.go('/orders');
        break;

      case 3:
        context.go('/categories');
        break;
    }
  }

  static CustomTransitionPage _customPage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0);
        const end = Offset.zero;

        final slideAnimation = Tween<Offset>(
          begin: begin,
          end: end,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        final fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
