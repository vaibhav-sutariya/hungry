// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/services/url_launcher.dart';
import 'package:hungry/res/components/app_bar/widgets/drawer_expansion_tile.dart';
import 'package:hungry/res/components/app_bar/widgets/drawer_tile.dart';
import 'package:hungry/res/routes/routes_name.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.showLogOut,
  });
  final bool showLogOut;
  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.put(FeedbackController());
    log('MyDrawer build');
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (user != null && user.photoURL != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                if (user == null || user.photoURL == null)
                  const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50,
                  ),
                const SizedBox(height: 10),
                Text(
                  user != null ? user.displayName ?? 'User' : 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user != null ? user.email ?? 'User' : 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Get.toNamed(RouteName.bottomBar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Get.toNamed(RouteName.aboutUsScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_page_outlined),
            title: const Text('Contact'),
            onTap: () {
              Get.toNamed(RouteName.contactUsScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback'),
            onTap: () {
              feedbackController.launchFeedbackForm();
            },
          ),
          if (showLogOut) // Conditionally show the LogOut list tile
            if (FirebaseAuth.instance.currentUser != null)
              // User is logged in
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  // Sign out the user
                  FirebaseAuth.instance.signOut();

                  Get.offNamed(RouteName.loginScreen);
                },
              ),
          // User is not logged in
          if (FirebaseAuth.instance.currentUser == null)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Get.toNamed(RouteName.loginScreen);

                // Navigate to SignInScreen
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SignInScreen(
                //       buttonPressed: 'Login',
                //     ),
                //   ),
                // );
              },
            ),
          DrawerExpansionTile(
            title: 'Settings & Support',
            children: [
              DrawerTile(
                icon: Icons.settings,
                title: 'Settings & Privacy',
                onTap: () {
                  Get.toNamed(RouteName.settingPrivacyScreen);
                },
              ),
              DrawerTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () {
                  Get.toNamed(RouteName.helpCenterScreen);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Add some spacing
          const Divider(), // Add a divider
          Text(
            'Hungry',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            'Version 1.2.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
