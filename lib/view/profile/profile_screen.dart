import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/profile/widgets/action_tiles_grid_widget.dart';
import 'package:hungry/view/profile/widgets/contributions_card_widget.dart';
import 'package:hungry/view/profile/widgets/donations_list_widget.dart';
import 'package:hungry/view/profile/widgets/profile_actions_widget.dart';
import 'package:hungry/view/profile/widgets/profile_header_widget.dart';
import 'package:hungry/view_models/controllers/profile_view_model/profile_view_model.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeaderWidget(user: viewModel.user.value),
                const SizedBox(height: 24),
                ContributionsCardWidget(
                  totalDonations: viewModel.totalDonations.value,
                ),
                const SizedBox(height: 20),
                ActionTilesGridWidget(
                  actionTiles: viewModel.actionTiles,
                ),
                const SizedBox(height: 20),
                DonationsListWidget(
                  donations: viewModel.donations,
                ),
                const SizedBox(height: 20),
                ProfileActionsWidget(
                  onEditProfile: () {
                    // Navigate to Edit Profile Screen
                  },
                  onLogout: () async {
                    await viewModel.signOut();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
