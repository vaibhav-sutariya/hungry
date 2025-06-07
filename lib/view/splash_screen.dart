import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hungry/res/assets/icon_assets.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Timer(const Duration(seconds: 2), () async {
      if (user != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.getBool('isFoodBank') == true) {
          log("Food Bank is registered");
          log("Navigating to registered food bank screen");
          log("User ID: ${user.uid}");
          log('${sharedPreferences.getBool('isFoodBank')}');

          Get.toNamed(RouteName.registedFoodBankScreen);
        } else if (sharedPreferences.getBool('isVolunteer') == true) {
          log("Volunteer is registered");
          log("Navigating to registered volunteer screen");
          Get.toNamed(RouteName.registedVolunteerScreen);
        } else {
          Get.offNamed(RouteName.homeScreen);
        }
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
