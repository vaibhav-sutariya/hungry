import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view/donations/widgets/donation_form_widget.dart';
import 'package:hungry/view/donations/widgets/donation_list_widget.dart';
import 'package:hungry/view_models/controllers/donation_view_model/donation_view_model.dart';

import '../../res/components/app_bar/app_bar.dart';
import '../../res/components/app_bar/drawer.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ViewModel
    final DonationViewModel viewModel = Get.put(DonationViewModel());

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Donations 🍽️',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Donation List
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Obx(() => DonationListWidget(
                    donations: viewModel.donations,
                    isLoading: viewModel.isLoading.value,
                  )),
            ),

            const SizedBox(height: 20),

            // Donation Form
            DonationFormWidget(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
