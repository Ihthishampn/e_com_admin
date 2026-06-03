import '../utils/themes/app_colors.dart';
import 'custom_textfield.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final double? width;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  const CustomSearchField({
    super.key,
    this.width,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: width,
      child: CustomTextField(
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        suffixIcon: Icon(Icons.search),
        hintText: hintText ?? 'Search here',
        borderSide: BorderSide(color: AppColors.primaryColor),
        borderRadius: 12,
      ),
    );
  }
}

