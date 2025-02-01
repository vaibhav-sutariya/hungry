import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/view/home/componets/custom_button.dart';
import 'package:hungry/view/home/componets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome Back, ',
                    style: TextStyle(
                      color: AppColors
                          .kPrimaryColor, // Change the color for "Welcome Back"
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    // text: user != null ? user.displayName ?? 'User' : 'Guest',
                    style: const TextStyle(
                      color: Colors.grey, // Keep the color for the username
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          // AddressBox(
          //   initialAddress: _currentAddress,
          // ),
          // const SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Are You Hungry?'),
                  CustomButton(
                    text: 'Find Food',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) =>
                      //         HomeScreen(currentAddress: _currentAddress),
                      //   ),
                      // );
                    },
                    background: AppColors.kPrimaryColor,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomText(text: 'You have leftover Food?'),
                  CustomButton(
                      onPressed: () {
                        // Get.to(() => user != null
                        //     ? AddFoodDetails()
                        //     : SignInScreen(
                        //         buttonPressed: "Submit Remaining Food"));
                      },
                      text: 'Submit Leftover Food'),
                  const SizedBox(height: 16),
                  CustomText(text: 'Want to help us?'),
                  CustomButton(
                      onPressed: () {
                        // Get.to(() => user != null
                        //     ? AddLocationDetails()
                        //     : SignInScreen(
                        //         buttonPressed: "Add more Locations"));
                      },
                      text: 'Add more Locations'),
                  const SizedBox(height: 16),
                  CustomText(text: 'Want to register your Food Bank or NGO?'),
                  CustomButton(
                      onPressed: () {
                        // Get.to(() => user != null
                        //     ? AddFoodBankDetails()
                        //     : SignInScreen(
                        //         buttonPressed: "Register Food Center"));
                      },
                      text: 'Register Food Center'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
