import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view/volunteer_registration/volunteer_details_confirmation_screen.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:uuid/uuid.dart';

class VolunteerRegistrationViewModel extends GetxController {
  LocationServices locationServices = LocationServices();
  final fnameController = TextEditingController().obs;
  final dobController = TextEditingController().obs;
  final genderController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final reasonController = TextEditingController().obs;
  final detailsController = TextEditingController().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;

  Future<void> saveVolunteerData() async {
    loading.value = true; // Show loading while fetching location

    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      String id = const Uuid().v4();

      if (user != null) {
        String userId = user.uid;
        String fName = fnameController.value.text.trim();
        String dob = dobController.value.text.trim();
        String gender = genderController.value.text.trim();
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
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });

        log("Volunteer data saved to Realtime Database");
      }
    } catch (e) {
      log("Error saving volunteer data to Realtime Database: $e");
    } finally {
      loading.value = false;
      Get.to(() => VolunteerDetailConfirmationScreen(
            firstName: fnameController.value.text,
            dob: dobController.value.text,
            gender: genderController.value.text,
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
