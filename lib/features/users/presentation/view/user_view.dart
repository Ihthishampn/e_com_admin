import 'dart:async';

import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/presentation/provider/user_provider.dart';
import 'package:e_com_admin/features/users/presentation/widgets/widgets_of_user_view.dart/user_list_tile.dart';
import 'package:e_com_admin/general/widgets/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  Timer? _debounce;
  Future<List<UserModel>>? _currentFuture;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCurrentFuture(context.read<UserProvider>().fetchUserModel());
    });
  }

  void _onSearchChanged(String raw) {
    final q = raw.trim();
    if (mounted) setState(() {});

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (q.isEmpty) {
        _setCurrentFuture(context.read<UserProvider>().fetchUserModel());
      } else {
        _setCurrentFuture(context.read<UserProvider>().searchUserModel(q));
      }
    });
  }

  void _setCurrentFuture(Future<List<UserModel>> future) {
    setState(() {
      _isSearching = true;
      _currentFuture = future;
    });
    future.whenComplete(() {
      if (!mounted) return;
      setState(() => _isSearching = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Users',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 260,
                  height: 42,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'search here',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : (_searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null),
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
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _currentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                allUsers = snapshot.data ?? [];
                filteredUsers = allUsers;

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No users found',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];

                      return UserListTile(
                        users: user,
                        onTap: () {
                          context.go(
                            '/users/userDetails?userId=${user.id}',
                          );
                        },
                      );
                    },
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
