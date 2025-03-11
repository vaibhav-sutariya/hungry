import 'package:flutter/material.dart';
import 'package:hungry/models/donation_model.dart';

class DonationsListWidget extends StatelessWidget {
  final List<DonationModel> donations;

  const DonationsListWidget({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Donations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        donations.isEmpty
            ? const Center(child: Text("You haven't made any donations yet."))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  var donation = donations[index];
                  return Card(
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
                      trailing: const Icon(Icons.fastfood, color: Colors.green),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
