import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/view_models/services/firebase_services/donation_services.dart';

class DonationViewModel extends GetxController {
  var donationFields = <TextEditingController>[TextEditingController()].obs;

  final DonationService _donationService =
      Get.put<DonationService>(DonationService());
  final RxList<DonationModel> donations = <DonationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDonations();
  }

  void addDonationField() {
    donationFields.add(TextEditingController());
  }

  void removeDonationField(int index) {
    if (donationFields.length > 1) {
      donationFields.removeAt(index);
    }
  }

  Future<void> submitDonation() async {
    List<String> donatedItems = donationFields
        .map((controller) => controller.text.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    if (donatedItems.isEmpty) {
      Get.snackbar("Error", "Please enter at least one food item!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    bool success = await _donationService.addDonation(donatedItems);
    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Donation Submitted Successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      donationFields.clear();
      donationFields.add(TextEditingController());
    } else {
      Get.snackbar("Error", "Failed to submit donation!",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _fetchDonations() {
    isLoading.value = true;

    _donationService.getAllDonations().listen((donationsList) {
      donations.value = donationsList;
      isLoading.value = false;
    });
  }
}
