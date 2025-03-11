import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/models/donation_model.dart';
import 'package:hungry/view_models/services/firebase_services/donation_services.dart';

class DonationViewModel extends GetxController {
  final DonationService _donationService =
      Get.put<DonationService>(DonationService());

  // Controllers for input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Observable donations list
  final RxList<DonationModel> donations = <DonationModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDonations();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _fetchDonations() {
    _donationService.getAllDonations().listen((donationsList) {
      donations.value = donationsList;
    });
  }

  Future<void> addDonation() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    bool success = await _donationService.addDonation(
      titleController.text.trim(),
      descriptionController.text.trim(),
    );

    isLoading.value = false;

    if (success) {
      // Clear fields after successful donation
      titleController.clear();
      descriptionController.clear();

      Get.snackbar(
        'Success',
        'Donation added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to add donation',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
