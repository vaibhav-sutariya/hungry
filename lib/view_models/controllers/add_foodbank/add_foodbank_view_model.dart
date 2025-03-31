import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:uuid/uuid.dart';

class AddFoodbankViewModel extends GetxController {
  // Location services instance
  LocationServices locationServices = LocationServices();

  // Controllers for form fields
  final foodNGoNameController = TextEditingController().obs;
  final fNameController = TextEditingController().obs;
  final gmailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final volunteerController = TextEditingController().obs;
  final minPeopleAcceptedController = TextEditingController().obs;

  // Checkbox states
  RxBool acceptingRemainingFood = false.obs;
  RxBool distributingToNeedyPerson = false.obs;
  RxBool freeMealAvailable = false.obs;
  RxBool acceptingDonations = false.obs;
  RxBool acceptTermsAndConditions = false.obs;

  // Form validation key
  final formKey = GlobalKey<FormState>().obs;

  // Loading state
  RxBool loading = false.obs;

  // Toggle checkbox states
  void toggleAcceptingRemainingFood(bool? value) {
    acceptingRemainingFood.value = value ?? false;
  }

  void toggleDistributingToNeedyPerson(bool? value) {
    distributingToNeedyPerson.value = value ?? false;
  }

  void toggleFreeMealAvailable(bool? value) {
    freeMealAvailable.value = value ?? false;
  }

  void toggleAcceptingDonations(bool? value) {
    acceptingDonations.value = value ?? false;
  }

  void toggleAcceptTermsAndConditions(bool? value) {
    acceptTermsAndConditions.value = value ?? false;
  }

  Future<void> saveFoodBankData() async {
    if (!acceptTermsAndConditions.value) {
      Get.snackbar("Error", "You must accept the Terms & Conditions.");
      return;
    }

    loading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      String id = const Uuid().v4();

      if (user != null) {
        String userId = user.uid;
        String foodNGOName = foodNGoNameController.value.text.trim();
        String fName = fNameController.value.text.trim();
        String gmail = gmailController.value.text.trim();
        String phone = phoneController.value.text.trim();
        String address = addressController.value.text.trim();
        String volunteer = volunteerController.value.text.trim();
        String minPeople = acceptingRemainingFood.value
            ? minPeopleAcceptedController.value.text.trim()
            : '';

        await databaseReference.child('FoodBanks').child(userId).child(id).set({
          'name': fName,
          'FoodBankName': foodNGOName,
          'gmail': gmail,
          'phone': phone,
          'volunteers': volunteer,
          'address': address,
          'services': {
            'acceptingRemainingFood': acceptingRemainingFood.value,
            'minPeopleAccepted': minPeople,
            'distributingToNeedyPerson': distributingToNeedyPerson.value,
            'freeMealAvailable': freeMealAvailable.value,
            'acceptingDonations': acceptingDonations.value,
          },
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        log("Location data saved to Realtime Database");
      }
    } catch (e) {
      log("Error saving location data to Realtime Database: $e");
    } finally {
      loading.value = false;
    }
  }

  RxList<String?> errors = <String?>[].obs;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }
}
