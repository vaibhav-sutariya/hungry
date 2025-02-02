import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';

class SingupViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final cPasswordController = TextEditingController().obs;

  final emailFocusnode = FocusNode().obs;
  final passwordFocusnode = FocusNode().obs;
  final cPasswordFocusnode = FocusNode().obs;

  final formkey = GlobalKey<FormState>().obs;

  RxBool loading = false.obs;

  void signUp() async {
    loading.value = true;
    String email = emailController.value.text.trim();
    String password = passwordController.value.text.trim();
    if (emailController.value.text == '' &&
        passwordController.value.text == '') {
      Get.snackbar(
          'Parameters cannot empty', 'Please fill the email and password');
    } else if (passwordController.value.text !=
        cPasswordController.value.text) {
      Get.snackbar('Error:', 'Password and Confirm Password not match');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Get.snackbar('Success:', 'SignUp Success');
          Get.toNamed(RouteName.loginScreen);
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
