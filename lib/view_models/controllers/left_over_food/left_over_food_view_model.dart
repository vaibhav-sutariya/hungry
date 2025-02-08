import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/view/leftover_food/food_confirmation_screen.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:uuid/uuid.dart';

class LeftOverFoodViewModel extends GetxController {
  LocationServices locationServices = LocationServices();
  final fnameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final personNumberController = TextEditingController().obs;
  final detailsController = TextEditingController().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;

  Future<void> saveLeftoverFoodData() async {
    loading.value = true; // Show loading while fetching location

    try {
      Position position = await Geolocator.getCurrentPosition();

      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      String id = const Uuid().v4();

      if (user != null) {
        String userId = user.uid;
        String fName = fnameController.value.text.trim();
        String phone = phoneController.value.text.trim();
        String address = addressController.value.text.trim();
        String persons = personNumberController.value.text.trim();
        String details = detailsController.value.text.trim();

        await databaseReference
            .child('leftOverFood')
            .child(userId)
            .child(id)
            .set({
          'fName': fName,
          'phone': phone,
          'address': address,
          'persons': persons,
          'details': details,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          }, // Store location as a map
        });

        log("User data saved to Realtime Database");
      }
    } catch (e) {
      log("Error saving user data to Realtime Database: $e");
    } finally {
      loading.value = false;
      Get.to(() => FoodConfirmationScreen(
            firstName: fnameController.value.text,
            phoneNumber: phoneController.value.text,
            address: addressController.value.text,
            details: detailsController.value.text,
            persons: personNumberController.value.text,
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
