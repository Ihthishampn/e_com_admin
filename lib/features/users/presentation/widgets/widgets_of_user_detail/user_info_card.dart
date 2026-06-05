import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserInfoCard extends StatelessWidget {
  final String userId;
  final String initial;
  final String displayName;
  final String phoneNumber;

  const UserInfoCard({
    Key? key,
    required this.userId,
    required this.initial,
    required this.displayName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ID: $userId',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
        const Gap(16),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF2D2D2D),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userField('Name', displayName),
                const Gap(8),
                _userField('Phone Number', phoneNumber),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _userField(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const Text(':  ', style: TextStyle(fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
