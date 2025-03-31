import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/view/donations/widgets/donation_form_widget.dart';
import 'package:hungry/view/donations/widgets/donation_list_widget.dart';
import 'package:hungry/view_models/controllers/donation_view_model/donation_view_model.dart';

import '../../res/components/app_bar/drawer.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ViewModel
    final DonationViewModel viewModel = Get.put(DonationViewModel());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(showLogOut: true),
        body: Column(
          children: [
            SizedBox(height: 10),
            TabBar(
              dividerColor: AppColors.kPrimaryColor,
              labelColor: AppColors.kPrimaryColor,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.mulish().fontFamily,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontFamily: GoogleFonts.mulish().fontFamily,
              ),
              unselectedLabelColor: AppColors.kTextColor,
              indicatorColor: AppColors.kPrimaryColor,
              indicatorWeight: 3,
              tabs: [
                Tab(text: "Donations"),
                Tab(text: "New Donation"),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              // Ensure TabBarView takes up remaining space
              child: TabBarView(
                children: [
                  // Donation List Tab
                  Obx(() => DonationListWidget(
                        donations: viewModel.donations,
                        isLoading: viewModel.isLoading.value,
                      )),

                  // Donation Form Tab
                  DonationFormWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
