import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/home/componets/address_box.dart';
import 'package:hungry/view/home/componets/custom_button.dart';
import 'package:hungry/view/home/componets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 1),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome Back, ',
                    style: TextStyle(
                      color: AppColors
                          .kPrimaryColor, // Change the color for "Welcome Back"
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.mulish().fontFamily,
                    ),
                  ),
                  TextSpan(
                    text: user != null ? user.displayName ?? 'User' : 'Guest',
                    style: TextStyle(
                      color: AppColors
                          .kSecondaryColor, // Keep the color for the username
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.mulish().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 25),
            AddressBox(),
            // const SizedBox(height: 20),
            Expanded(
              child: Column(
                // spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Are You Hungry?'),
                  CustomButton(
                    text: 'Find Food',
                    onPressed: () {
                      Get.toNamed(RouteName.findFoodScreen);
                    },
                    background: AppColors.kPrimaryColor,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomText(text: 'You have leftover Food?'),
                  CustomButton(
                      onPressed: () {
                        Get.toNamed(user != null
                            ? RouteName.submitLeftoverFoodScreen
                            : RouteName.loginScreen);
                      },
                      text: 'Submit Leftover Food'),
                  const SizedBox(height: 16),
                  CustomText(text: 'Want to help us?'),
                  CustomButton(
                      onPressed: () {
                        Get.toNamed(user != null
                            ? RouteName.addLocationScreen
                            : RouteName.loginScreen);
                      },
                      text: 'Add more Locations'),
                  const SizedBox(height: 16),
                  CustomText(text: 'Want to register your Food Bank or NGO?'),
                  CustomButton(
                      onPressed: () {
                        Get.toNamed(user != null
                            ? RouteName.foodBankScreen
                            : RouteName.loginScreen);
                      },
                      text: 'Register Food Center'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
