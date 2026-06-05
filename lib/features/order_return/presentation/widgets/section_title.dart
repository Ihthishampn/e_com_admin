import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String label;

  const SectionTitle({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
