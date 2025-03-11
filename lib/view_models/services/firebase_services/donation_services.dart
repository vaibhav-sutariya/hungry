import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';

class DonationService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? get currentUser => _auth.currentUser;

  // Add a new donation
  Future<bool> addDonation(String title, String description) async {
    final user = currentUser;
    if (user == null || title.isEmpty || description.isEmpty) {
      return false;
    }

    try {
      DatabaseReference donationRef = _database.child('donations').push();
      await donationRef.set({
        'title': title,
        'description': description,
        'timestamp': ServerValue.timestamp,
        'userId': user.uid,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all donations stream
  Stream<List<DonationModel>> getAllDonations() {
    return _database.child('donations').onValue.map((event) {
      final data = event.snapshot.value;
      List<DonationModel> donations = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          // Extract the userId from the donation data
          final userId = value['userId'] ?? '';
          donations.add(DonationModel.fromMap(value, key, userId));
        });
      }

      // Sort by timestamp (newest first)
      donations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return donations;
    });
  }
}
