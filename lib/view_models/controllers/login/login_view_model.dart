import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusnode = FocusNode().obs;
  final passwordFocusnode = FocusNode().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;

  void login() async {
    loading.value = true;
    String email = emailController.value.text.trim();
    String password = passwordController.value.text.trim();
    if (emailController.value.text == '' &&
        passwordController.value.text == '') {
      Get.snackbar(
          'Parameters cannot empty', 'Please fill the email and password');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Get.snackbar('Success:', 'Login Success');
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
}
