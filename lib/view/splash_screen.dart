import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hungry/res/assets/icon_assets.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (user != null) {
        Get.offNamed(RouteName.bottomBar);
      } else {
        Get.toNamed(RouteName.loginScreen);
      }
    });
  }

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
