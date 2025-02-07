import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:uuid/uuid.dart';

class AddLocationViewModel extends GetxController {
  LocationServices locationServices = LocationServices();
  final fnameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final detailsController = TextEditingController().obs;
  final formkey = GlobalKey<FormState>().obs;
  RxBool loading = false.obs;

  RxMap<String, bool> categories = {
    'Temples': false,
    'Food Banks': false,
    'NGO': false,
    'Gov. Food Center': false,
  }.obs;

  void toggleCategorySelection(String category, bool? value) {
    if (value != null) {
      categories[category] = value;
    }
  }

  Future<void> saveLocationData() async {
    loading.value = true;
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
        String details = detailsController.value.text.trim();

        List<String> selectedCategories = categories.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

        await databaseReference.child('locations').child(userId).child(id).set({
          'fName': fName,
          'phone': phone,
          'address': address,
          'details': details,
          'categories': selectedCategories,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
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
