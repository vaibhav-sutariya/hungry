import 'package:flutter/material.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:intl/intl.dart';

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
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
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
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.kPrimaryColor),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Items Donated: ${donation.items.join(", ")}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "Donated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(donation.timestamp))}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            trailing:
                                const Icon(Icons.fastfood, color: Colors.green),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
