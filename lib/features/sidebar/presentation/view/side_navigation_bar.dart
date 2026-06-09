import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../general/services/go_route/route_config.dart';

class SideNavigationBar extends StatefulWidget {
  final Widget child;
  const SideNavigationBar({super.key, required this.child});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final String currentPath = state.uri.path;
    RouteConfig.calculateSelectedIndexFromPath(currentPath);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Version demo',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      //   const Text(
                      //   'Version ${AppDetails.version}',
                      //   style: TextStyle(
                      //     color: Colors.grey,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildMenuItem('Users', 0, currentPath),
                        _buildMenuItem('Products', 1, currentPath),
                        _buildMenuItem('Order & Return', 2, currentPath),
                        _buildMenuItem('Category Management', 3, currentPath),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, int index, String currentPath) {
    bool isSelected =
        RouteConfig.calculateSelectedIndexFromPath(currentPath) == index;

    return InkWell(
      onTap: () {
        RouteConfig.onItemTapped(index, context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
