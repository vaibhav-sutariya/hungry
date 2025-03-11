import 'package:flutter/material.dart';
import 'package:hungry/view_models/controllers/donation_view_model/donation_view_model.dart';

class DonationFormWidget extends StatelessWidget {
  final DonationViewModel viewModel;

  const DonationFormWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Donate Food 🍛',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Food Name Field
        _buildTextField(viewModel.titleController, 'Food/Ingredient Name',
            Icons.fastfood, Colors.orange),
        const SizedBox(height: 15),

        // Description Field
        _buildTextField(viewModel.descriptionController, 'Description',
            Icons.description, Colors.blue,
            maxLines: 3),
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
            onPressed: viewModel.addDonation,
            icon: const Icon(Icons.volunteer_activism, color: Colors.white),
            label: const Text("Donate Now",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // Helper method to create text fields with consistent design
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, Color iconColor,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3)),
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
        ),
        maxLines: maxLines,
      ),
    );
  }
}
