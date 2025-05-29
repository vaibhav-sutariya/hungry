import 'package:flutter/material.dart';

class DonationDetailsScreen extends StatelessWidget {
  const DonationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    final String id = args['id'] ?? 'N/A';
    final String name = args['name'] ?? 'Unknown';
    final String address = args['address'] ?? 'No address provided';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donation ID: $id',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Donor: $name',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: $address',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add action, e.g., contact donor or claim donation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action not implemented')),
                );
              },
              child: const Text('Claim Donation'),
            ),
          ],
        ),
      ),
    );
  }
}
