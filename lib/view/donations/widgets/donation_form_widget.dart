import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/controllers/donation_view_model/donation_view_model.dart';

class DonationFormWidget extends StatelessWidget {
  final DonationViewModel viewModel = Get.put(DonationViewModel());

  DonationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Donate Food 🍛',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Donation Fields List (Dynamically Updated)
            Obx(() => Column(
                  children: List.generate(
                    viewModel.donationFields.length,
                    (index) => Column(
                      children: [
                        _buildTextField(
                          viewModel.donationFields[index],
                          'Food/Ingredient Name',
                          Icons.fastfood,
                          Colors.orange,
                          index,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )),

            // Add More Fields Button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: viewModel.addDonationField,
                icon: const Icon(Icons.add_circle, color: Colors.green),
                label: const Text("Add More",
                    style: TextStyle(color: Colors.green, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),

            // Donate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: viewModel.submitDonation,
                icon: const Icon(Icons.volunteer_activism, color: Colors.white),
                label: const Text("Donate Now",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create text fields with suffix icon for removal
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, Color iconColor, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          prefixIcon: Icon(icon, color: iconColor),

          // Remove button as suffix icon (only if more than one field)
          suffixIcon: viewModel.donationFields.length > 1
              ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => viewModel.removeDonationField(index),
                )
              : null,
        ),
      ),
    );
  }
}
