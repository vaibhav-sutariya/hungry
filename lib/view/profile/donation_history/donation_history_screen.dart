import 'package:flutter/material.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class DonationHistoryScreen extends StatelessWidget {
  final List<DonationModel> donations;
  const DonationHistoryScreen({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "My Donations",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimaryColor),
              ),
            ),
            const SizedBox(height: 10),
            donations.isEmpty
                ? const Center(
                    child: Text("You haven't made any donations yet."))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      var donation = donations[index];
                      return Card(
                        color: AppColors.kWhiteColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            donation.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(donation.description),
                          trailing:
                              const Icon(Icons.fastfood, color: Colors.green),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
