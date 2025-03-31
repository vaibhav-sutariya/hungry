import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';

class DonationService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? get currentUser => _auth.currentUser;

  Future<bool> addDonation(List<String> donations) async {
    final user = currentUser;
    if (user == null) return false;

    try {
      DatabaseReference donationRef = _database.child('donations').push();
      await donationRef.set({
        'donations': donations,
        'timestamp': ServerValue.timestamp,
        'userId': user.uid,
      });
      log('Donation added: ${donationRef.key}');
      return true;
    } catch (e) {
      log('Error adding donation: $e');
      Get.snackbar("Error", "Failed to add donation!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Stream<List<DonationModel>> getAllDonations() {
    return _database.child('donations').onValue.map((event) {
      final data = event.snapshot.value;
      List<DonationModel> donations = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          final userId = value['userId'] ?? '';
          donations.add(DonationModel.fromMap(value, key, userId));
        });
        log('Fetched donations: ${donations.length}');
      }

      donations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return donations;
    });
  }
}
