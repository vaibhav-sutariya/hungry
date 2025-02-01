import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry/res/assets/icon_assets.dart';
import 'package:hungry/res/colors/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.kPrimaryColor,
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              IconAssets.splashIcon,
              width: 200, // Adjust the width as needed
            ),
            const Text(
              'Meals For Everyone...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
