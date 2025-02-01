import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.foreground,
      this.background});
  VoidCallback onPressed;
  String text;
  Color? foreground;
  Color? background;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foreground ?? AppColors.kPrimaryColor, // Text color
        backgroundColor: background ?? Colors.white, // Text color
        padding: const EdgeInsets.all(16), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 2.0,
          ), // Rounded corners
        ),
        // elevation: 5, // Elevation (shadow)
        minimumSize: const Size(double.infinity, 0), // Full width
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
