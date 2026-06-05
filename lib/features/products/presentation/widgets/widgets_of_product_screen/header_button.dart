import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderButton extends StatelessWidget {
  final String text;

  const HeaderButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == "Add New Product") {
          context.go("/products/productAdd");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}
