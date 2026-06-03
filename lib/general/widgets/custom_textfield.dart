import 'package:e_com_admin/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.hintText,
      this.maxLength,
      this.suffixIcon,
      this.prefixText,
      this.suffixText,
      this.onTap,
      this.onChanged,
      this.readOnly = false,
      this.onFieldSubmitted,
      this.controller,
      this.keyboardType,
      this.maxLines,
      this.validator,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next,
      this.labelText,
      this.styleColor,
      this.obscureText = false,
      this.obscuringCharacter = '*',
      this.autovalidateMode,
      this.inputFormatters,
      this.textCapitalization = TextCapitalization.none,
      this.focusNode,
      this.abovetext,
      this.textStar,
      this.borderSide = const BorderSide(
        color: AppColors.textFieldBorder,
      ),
      this.borderRadius = 8,
      this.fillColor,
      this.suffixColor,
      this.prefixColor,
      this.overflow = TextOverflow.ellipsis});
  final String? hintText;
  final int? maxLength;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String? value)? validator;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final String? labelText;
  final Color? styleColor;
  final bool obscureText;
  final String obscuringCharacter;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? abovetext;
  final bool? textStar;
  final BorderSide borderSide;
  final double borderRadius;
  final String? prefixText;
  final String? suffixText;
  final Color? suffixColor;
  final Color? prefixColor;
  final Color? fillColor;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (abovetext != null)
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Text(abovetext ?? '',
                    overflow: overflow,
                    style: TextStyle(
                      color: AppColors.lightBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    )),
                if (textStar == true)
                  Row(
                    children: [
                      const Gap(2),
                      Text(
                        '*',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        TextFormField(
          
          validator: validator,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          autovalidateMode: autovalidateMode,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          cursorColor: AppColors.black,
          controller: controller,
          readOnly: readOnly,
          maxLength: maxLength,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: styleColor ?? AppColors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            overflow: overflow,
          ),
          textInputAction: textInputAction,
          decoration: InputDecoration(
            isDense: true,
            suffixText: suffixText,
            prefixText: prefixText,
            suffixStyle: TextStyle(
              fontSize: 14,
              color: suffixColor ?? AppColors.black,
              fontWeight: FontWeight.w500,
              overflow: overflow,
            ),
            prefixStyle: TextStyle(
              fontSize: 14,
              color: prefixColor ?? AppColors.black,
              fontWeight: FontWeight.w500,
              overflow: overflow,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            labelText: labelText,
            labelStyle: TextStyle(
              color: AppColors.lightBlack.withOpacity(.5),
              fontWeight: FontWeight.w400,
              fontSize: 12,
              overflow: overflow,
            ),
            hintStyle: TextStyle(
              color: AppColors.lightBlack.withOpacity(.5),
              fontWeight: FontWeight.w400,
              fontSize: 12,
              overflow: overflow,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: borderSide),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: borderSide),
            filled: true,
            fillColor: fillColor ?? AppColors.textField,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: AppColors.textFieldBorder)),
          ),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown(
      {super.key,
      required this.items,
      this.onChanged,
      this.value,
      this.hintText,
      this.validator,
      this.borderSide = const BorderSide(
        color: AppColors.textFieldBorder,
      ),
      this.borderRadius = 8,
      this.fillColor,
      this.suffixColor,
      this.prefixColor,
      this.overflow = TextOverflow.ellipsis,
      this.abovetext,
      this.textStar});
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final String? hintText;
  final String? Function(String? value)? validator;
  final BorderSide borderSide;
  final double borderRadius;
  final Color? fillColor;
  final Color? suffixColor;
  final Color? prefixColor;
  final String? abovetext;
  final bool? textStar;
  final TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (abovetext != null)
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Text(abovetext ?? '',
                    overflow: overflow,
                    style: TextStyle(
                      color: AppColors.lightBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    )),
                if (textStar == true)
                  Row(
                    children: [
                      const Gap(2),
                      Text(
                        '*',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((String item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: AppColors.lightBlack.withOpacity(.5),
                fontSize: 12,
                overflow: overflow),
            labelStyle: TextStyle(
                color: AppColors.lightBlack.withOpacity(.5),
                fontSize: 12,
                overflow: overflow),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            filled: true,
            fillColor: fillColor ?? AppColors.textField,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: borderSide),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

