import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view/volunteer_registration/volunteer_details_confirmation_screen.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class VolunteerRegistrationViewModel extends GetxController {
  LocationServices locationServices = LocationServices();
  final fnameController = TextEditingController().obs;
  var selectedDOB = Rxn<DateTime>();
  RxString selectedGender = ''.obs; // Reactive variable
  final phoneController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final reasonController = TextEditingController().obs;
  final detailsController = TextEditingController().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;
  // Method to set the DOB
  void setDOB(DateTime dob) {
    selectedDOB.value = dob;
  }

  // Method to get formatted DOB
  String get formattedDOB {
    return selectedDOB.value != null
        ? DateFormat('dd-MM-yyyy').format(selectedDOB.value!)
        : DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  var genderOptions = ["Male", "Female", "Other"].obs; // List of genders
// Reactive variable for selected gender

  // Method to update the selected gender
  void setGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> saveVolunteerData() async {
    loading.value = true; // Show loading while fetching location

    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      String id = const Uuid().v4();

      if (user != null) {
        String userId = user.uid;
        String fName = fnameController.value.text.trim();
        String dob = formattedDOB;
        String gender = selectedGender.string;
        String phone = phoneController.value.text.trim();
        String email = emailController.value.text.trim();
        String address = addressController.value.text.trim();
        String reason = reasonController.value.text.trim();

        await databaseReference
            .child('volunteers')
            .child(userId)
            .child(id)
            .set({
          'fName': fName,
          'dob': dob,
          'gender': gender,
          'phone': phone,
          'email': email,
          'address': address,
          'reason': reason,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('isVolunteer', true);

        log("Volunteer data saved to Realtime Database");
      }
    } catch (e) {
      log("Error saving volunteer data to Realtime Database: $e");
    } finally {
      loading.value = false;
      Get.to(() => VolunteerDetailConfirmationScreen(
            firstName: fnameController.value.text,
            dob: formattedDOB,
            gender: selectedGender.string,
            phoneNumber: phoneController.value.text,
            email: emailController.value.text,
            address: addressController.value.text,
            reason: reasonController.value.text,
            id: const Uuid().v4(),
          ));
    }
  }

  RxList<String?> errors = <String?>[].obs;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      // setState(() {
      errors.add(error);
      // });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      // setState(() {
      errors.remove(error);
      // });
    }
  }
}
