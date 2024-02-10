import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunger/screens/addFood/FoodDetailsScreen.dart';
import 'package:hunger/screens/addFood/addFoodDetails.dart';
import 'package:hunger/screens/addFood/mapScreen.dart';
import 'package:uuid/uuid.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class AddFoodDetailsForm extends StatefulWidget {
  const AddFoodDetailsForm({super.key});

  @override
  State<AddFoodDetailsForm> createState() => _AddFoodDetailsFormState();
}

class _AddFoodDetailsFormState extends State<AddFoodDetailsForm> {
  TextEditingController FnameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detialsController = TextEditingController();
  LatLng? selectedLocation;

  String? userId;

  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? phoneNumber;
  String? address;
  String? details;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: FnameController,
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Full Name",
              hintText: "Enter your full name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: PhoneController,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: addressController,
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Address",
              hintText: "Enter your address",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(
                  svgIcon: "assets/icons/Location point.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: detialsController,
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kDetailsNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kDetailsNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Details",
              hintText: "Enter your details",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 35.0, horizontal: 12.0),
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(
                  svgIcon: "assets/icons/Chat bubble Icon.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
                side: const BorderSide(color: kPrimaryColor, width: 2),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            ),
            onPressed: () async {
              // _openMapToSelectLocation();
              if (_formKey.currentState!.validate()) {
                // Save the form data
                _formKey.currentState!.save();

                // Navigate to the map screen to select a location
                LatLng? location = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      firstName: FnameController.text.trim(),
                      phoneNumber: PhoneController.text.trim(),
                      address: addressController.text.trim(),
                      details: detialsController.text.trim(),
                    ),
                  ),
                );

                // If a location is selected on the map screen, save the data to Firestore
                if (location != null) {
                  saveDataToFirestore(location);
                }
              }
            },
            child: const Text(
              "Select Location of Food Bank",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMapToSelectLocation() async {
    // Navigate to map screen where user can select location
    LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(
          firstName: '',
          phoneNumber: '',
          details: '',
          address: '',
        ),
      ),
    );

    if (location != null) {
      setState(() {
        selectedLocation = location;
      });
    }
  }

  void saveDataToFirestore(LatLng location) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      String Fname = FnameController.text.trim();
      String phone = PhoneController.text.trim();
      String address = addressController.text.trim();
      String details = detialsController.text.trim();
      String selectedLocationString =
          "${location.latitude},${location.longitude}";

      String id = const Uuid().v4();

      Map<String, dynamic> userData = {
        "id": id,
        "Fname": Fname,
        "phone": phone,
        "address": address,
        "details": details,
        "location": selectedLocationString,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .set(userData);

      log("User data saved to Firestore");

      // Check if the user document exists in Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // Navigate to FoodDetailsScreen only if user data exists
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const FoodDetailsScreen(),
          ),
        );
      } else {
        // Handle case where user data does not exist
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const AddFoodDetails(),
          ),
        );
        // You can provide feedback to the user or perform other actions here
      }
    }
  }
}