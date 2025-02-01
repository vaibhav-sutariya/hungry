import 'package:flutter/material.dart';

class AppColors {
  static const kPrimaryColor = Color(0xFFFF7A00);
  static const kPrimaryLightColor = Color(0xFFFFECDF);
  static const kPrimaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7A00), Color(0xFFFF7643)],
  );
  static const kSecondaryColor = Color(0xFF979797);
  static const kTextColor = Colors.black;

  static const kAnimationDuration = Duration(milliseconds: 200);

  static const headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.5,
  );

  static const defaultDuration = Duration(milliseconds: 250);

  static const TextStyle kTextStyleB = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: 0.5,
  );

  static const TextStyle kTextStyleN = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    letterSpacing: 0.5,
  );

// Form Error
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String kEmailNullError = "Please Enter your email";
  static const String kInvalidEmailError = "Please Enter Valid Email";
  static const String kPassNullError = "Please Enter your password";
  static const String kShortPassError = "Password is too short";
  static const String kMatchPassError = "Passwords don't match";
  static const String kNamelNullError = "Please Enter your name";
  static const String kPhoneNumberNullError = "Please Enter your phone number";
  static const String kPersonNullError = "Please Enter  Number of Persons";
  static const String kAddressNullError = "Please Enter your address";
  static const String kDetailsNullError = "Please Enter your details";

  static final otpInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
    border: outlineInputBorder(),
    focusedBorder: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
  );

  static OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kTextColor),
    );
  }
}
