import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';

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
          Get.snackbar('Success:', 'Login Success');
          Get.toNamed(RouteName.homeScreen);
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
