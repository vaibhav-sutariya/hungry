import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final Widget suffixIcon;
  final String? errorText;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    required this.labelText,
    required this.hintText,
    required this.suffixIcon,
    this.errorText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      cursorColor: AppColors.kPrimaryColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.kPrimaryColor,
        ),
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryColor,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }
}
