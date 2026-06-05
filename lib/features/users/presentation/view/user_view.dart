import 'package:e_com_admin/features/users/presentation/widgets/widgets_of_user_view.dart/user_list_tile.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminHeader(),

          const Gap(12),

          // Title + Search (UI only)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users (0)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  width: 260,
                  height: 42,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search here',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(12),

          // List UI only (static mock)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  return UserListTile(
                    userId: 'user_${index + 1}',
                    onTap: () {
                      context.go('/users/userDetails?userId=user_${index + 1}');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


