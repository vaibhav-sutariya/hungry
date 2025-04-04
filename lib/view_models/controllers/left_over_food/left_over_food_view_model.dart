import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hungry/view/leftover_food/food_confirmation_screen.dart';
import 'package:hungry/view_models/services/location_services/location_services.dart';
import 'package:hungry/view_models/services/notifications/access_token.dart';
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
          'numberOfPersons': persons,
          'details': details,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        log("left over data saved to Realtime Database");
      }
    } catch (e) {
      log("Error saving left over data to Realtime Database: $e");
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

  void sendNotification(String name, String address) {
    FirebaseFirestore.instance
        .collection('tokens')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String token = (doc.data() as Map<String, dynamic>)['token'];
        log(token);
        sendNotificationToToken(name, address, token);
      });
    }).catchError((error) {
      print("Error retrieving tokens: $error");
    });
  }

  void sendNotificationToToken(
      String name, String address, String token) async {
    log("Name: $name");
    log("Address: $address");
    var data = {
      "message": {
        "token": token,
        "notification": {
          "title": '${name} wants to donate their leftover food',
          "body": 'Address : ${address}',
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "sound": "default",
            "visibility": "PUBLIC",
          },
        }
      },
    };

    await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/hunger-cbd8e/messages:send'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await getAccessToken()}',
      },
    ).then((value) {
      if (value.statusCode == 200) {
        log("Notification sent successfully: ${value.body}");
      } else {
        log("Failed to send notification: ${value.body}");
      }
    }).onError((error, stackTrace) {
      log("Error sending notification: $error");
    });
  }
}
