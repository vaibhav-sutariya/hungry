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
        }).then((value) {
          log("left over data saved to Realtime Database");

          Get.to(() => FoodConfirmationScreen(
                firstName: fnameController.value.text,
                phoneNumber: phoneController.value.text,
                address: addressController.value.text,
                details: detailsController.value.text,
                persons: personNumberController.value.text,
                id: id,
              ));
        });
      } else {
        log("User is not logged in");
        Get.snackbar("Error", "User is not logged in",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      log("Error saving left over data to Realtime Database: $e");
    } finally {
      loading.value = false;
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

  void sendNotificationToAdmin(String id, String name, String address) async {
    try {
      // Fetch the specific document by ID
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('tokens')
          .doc('g03mKTcwBVX9QE1hCbsG1zRUPhq2') // Admin document ID
          .get();

      // Check if the document exists
      if (!docSnapshot.exists) {
        log('No token found for document ID admin: g03mKTcwBVX9QE1hCbsG1zRUPhq2');
        return;
      }

      // Validate document data
      final data = docSnapshot.data() as Map<String, dynamic>?;
      if (data == null ||
          !data.containsKey('token') ||
          data['token'] is! String) {
        log('Invalid or missing token in document admin: g03mKTcwBVX9QE1hCbsG1zRUPhq2');
        return;
      }

      final String token = data['token'] as String;
      if (token.isEmpty) {
        log('Empty token in document admin: g03mKTcwBVX9QE1hCbsG1zRUPhq2');
        return;
      }

      log('Sending notification to admin: $token');
      sendNotificationToToken(id, name, address, token);
    } catch (error, stackTrace) {
      log('Error retrieving token or sending notification: $error',
          error: error, stackTrace: stackTrace);
    }
  }

  void sendNotification(String id, String name, String address) {
    FirebaseFirestore.instance
        .collection('tokens')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String token = (doc.data() as Map<String, dynamic>)['token'];
        log(token);
        sendNotificationToToken(id, name, address, token);
      });
    }).catchError((error) {
      print("Error retrieving tokens: $error");
    });
  }

  void sendNotificationToToken(
      String id, String name, String address, String token) async {
    log("Name: $name");
    log("Address: $address");
    var data = {
      "message": {
        "token": token,
        "notification": {
          "title": '${name} wants to donate their leftover food',
          "body": 'Address : ${address}',
        },
        "data": {
          "id": id,
          "type": "leftover_food",
          "name": name,
          "address": address,
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
