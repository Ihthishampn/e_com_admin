import 'package:e_com_admin/features/order_return/presentation/widgets/info_row.dart';
import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserListTile extends StatelessWidget {
  final UserModel users;
  final VoidCallback onTap;

  const UserListTile({required this.users, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24, child: Text('A')),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(label: 'Name', value: users.name),
                      const Gap(4),
                      InfoRow(
                        label: 'Phone Number',
                        value: users.number,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
