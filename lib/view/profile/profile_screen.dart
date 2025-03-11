import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view/profile/widgets/contributions_card_widget.dart';
import 'package:hungry/view/profile/widgets/donations_list_widget.dart';
import 'package:hungry/view/profile/widgets/profile_actions_widget.dart';
import 'package:hungry/view/profile/widgets/profile_header_widget.dart';
import 'package:hungry/view_models/controllers/profile_view_model/profile_view_model.dart';

import '../../res/components/app_bar/app_bar.dart';
import '../../res/components/app_bar/drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ViewModel
    final ProfileViewModel viewModel = Get.put(ProfileViewModel());

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              children: [
                // Profile Header with user info
                ProfileHeaderWidget(user: viewModel.user.value),
                const SizedBox(height: 24),

                // User Statistics Card
                ContributionsCardWidget(
                  totalDonations: viewModel.totalDonations.value,
                ),
                const SizedBox(height: 20),

                // User Donations List
                DonationsListWidget(
                  donations: viewModel.donations,
                ),
                const SizedBox(height: 20),

                // Action Buttons
                ProfileActionsWidget(
                  onEditProfile: () {
                    // Navigate to Edit Profile Screen
                  },
                  onLogout: () async {
                    await viewModel.signOut();
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            )),
      ),
    );
  }
}
