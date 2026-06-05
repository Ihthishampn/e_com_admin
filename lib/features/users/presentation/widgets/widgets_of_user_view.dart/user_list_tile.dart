import 'package:e_com_admin/features/order_return/presentation/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserListTile extends StatelessWidget {
  final String userId;
  final VoidCallback onTap;

  const UserListTile({required this.userId, required this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: $userId',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Gap(10),

            Row(
              children: [
                const CircleAvatar(radius: 24, child: Text('A')),

                const Gap(16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InfoRow(label: 'Name', value: 'John Doe'),
                      const Gap(4),
                      const InfoRow(
                        label: 'Phone Number',
                        value: '+91 0000000000',
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
