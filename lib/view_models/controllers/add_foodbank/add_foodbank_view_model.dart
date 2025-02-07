import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:uuid/uuid.dart';

class AddFoodbankViewModel extends GetxController {
  LocationServices locationServices = LocationServices();
  final foodNGoNameController = TextEditingController().obs;
  final fNameController = TextEditingController().obs;
  final gmailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final volunteerController = TextEditingController().obs;
  final formkey = GlobalKey<FormState>().obs;
  RxBool loading = false.obs;

  Future<void> saveFoodBankData() async {
    loading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition();
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

        await databaseReference.child('FoodBanks').child(userId).child(id).set({
          'FoodNgoName': foodNGOName,
          'Fname': fName,
          'gmail': gmail,
          'phone': phone,
          'volunteers': volunteer,
          'address': address,
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
