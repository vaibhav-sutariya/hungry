import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(color: AppColors.kPrimaryColor, width: 1.0),
    ),
  );
}
