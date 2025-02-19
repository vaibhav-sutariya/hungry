import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hungry/res/routes/routes_name.dart';

class SignInWithGoogle extends GetxController {
  RxBool loading = false.obs;

  void signInWithGoogle() async {
    try {
      loading.value = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // if (googleUser != null) {
      //   throw Exception('Google Sign In Failed');
      // }
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log('Success: Login Success');
        Get.snackbar('Success', 'Login Success');
        Get.toNamed(RouteName.bottomBar);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      loading.value = false;
    }
  }
}
