import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Function to add a donation to RTDB
  Future<void> _addDonation() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    DatabaseReference donationRef =
        _database.child('donations').child(user.uid).push();
    await donationRef.set({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'timestamp': ServerValue.timestamp,
    });

    // Clear fields after adding
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<DatabaseEvent>(
                stream: _database.child('donations').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError ||
                      snapshot.data?.snapshot.value == null) {
                    return const Center(
                        child: Text("No donations available 😔"));
                  }

                  final Map<dynamic, dynamic> donationsData = (snapshot
                          .data!.snapshot.value as Map<dynamic, dynamic>?) ??
                      {};
                  final List<Map<String, dynamic>> donations = [];

                  donationsData.forEach((userId, userDonations) {
                    (userDonations as Map).forEach((donationId, donation) {
                      donations.add({
                        'id': donationId,
                        'title': donation['title'],
                        'description': donation['description'],
                        'timestamp': donation['timestamp'],
                      });
                    });
                  });

                  donations.sort((a, b) =>
                      (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              donation['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(donation['description'],
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            trailing: const Icon(Icons.fastfood_rounded,
                                color: Colors.green, size: 28),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Text(
              'Donate Food 🍛',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Food Name Field
            _buildTextField(_titleController, 'Food/Ingredient Name',
                Icons.fastfood, Colors.orange),
            const SizedBox(height: 15),

            // Description Field
            _buildTextField(_descriptionController, 'Description',
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
                onPressed: _addDonation,
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
