import 'package:flutter/material.dart';
import 'package:hungry/models/donation_model.dart';

class DonationListWidget extends StatelessWidget {
  final List<DonationModel> donations;
  final bool isLoading;

  const DonationListWidget({
    super.key,
    required this.donations,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donations.isEmpty) {
      return const Center(child: Text("No donations available 😔"));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        var donation = donations[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                donation.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(donation.description,
                    style: const TextStyle(fontSize: 14)),
              ),
              trailing: const Icon(Icons.fastfood_rounded,
                  color: Colors.green, size: 28),
            ),
          ),
        );
      },
    );
  }
}
