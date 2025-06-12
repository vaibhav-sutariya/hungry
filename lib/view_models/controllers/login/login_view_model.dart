import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view_models/services/notifications/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusnode = FocusNode().obs;
  final passwordFocusnode = FocusNode().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;

  void login() async {
    String email = emailController.value.text.trim();
    String password = passwordController.value.text.trim();
    if (emailController.value.text == '' &&
        passwordController.value.text == '') {
      Get.snackbar(
          'Parameters cannot empty', 'Please fill the email and password');
    } else {
      try {
        loading.value = true;

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          Get.snackbar('Success:', 'Login Success');
          if (sharedPreferences.getBool('isFoodBank') == true ||
              userCredential.user!.email == 'ngo123@gmail.com') {
            Get.offNamed(
              RouteName.registedFoodBankScreen,
            );
          } else if (sharedPreferences.getBool('isVolunteer') == true ||
              userCredential.user!.email == 'volunteer123@gmail.com') {
            Get.offNamed(
              RouteName.registedVolunteerScreen,
            );
          } else {
            Get.offNamed(RouteName.bottomBar);
          }
        }

        if (userCredential.user!.email == 'admin@hungry.com') {
          // Store the access token after successful login
          storeAccessToken();
        } else {
          log('User is not admin, no access token stored');
        }
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Error:', e.message.toString());
      } catch (e) {
        print(e);
      } finally {
        loading.value = false;
      }
    }
  }

  void storeAccessToken() {
    NotificationServices().getDeviceToken().then((token) async {
      // Ensure the user is authenticated before storing the token
      FirebaseAuth auth = FirebaseAuth.instance;
      String? authUserId = auth.currentUser?.uid;

      try {
        // Store the device token in Firestore
        await FirebaseFirestore.instance
            .collection('tokens')
            .doc(authUserId)
            .set({'token': token});

        log("Device Token: $token");
        print('Device token stored successfully in Firestore');
      } catch (error) {
        print('Failed to store device token: $error');
      }
    }).catchError((error) {
      log("Error getting device token: $error");
    });
  }

  // final _formKey = GlobalKey<FormState>();
  // String? email;
  // String? password;
  RxBool remember = false.obs;
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
