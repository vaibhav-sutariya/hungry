import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/left_over_food/left_over_food_view_model.dart';
import 'package:uuid/uuid.dart';

class FoodDetailsForm extends StatefulWidget {
  const FoodDetailsForm({super.key});

  @override
  State<FoodDetailsForm> createState() => _FoodDetailsFormState();
}

class _FoodDetailsFormState extends State<FoodDetailsForm> {
  LeftOverFoodViewModel leftOverFoodViewModel =
      Get.put(LeftOverFoodViewModel());

  String? userId;
  Position? _currentPosition;

  // final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     final Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   } catch (e) {
  //     log('Error getting current location: $e');
  //     // Handle error, such as showing a message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: leftOverFoodViewModel.formkey.value,
      child: Column(
        children: [
          CustomTextField(
            controller: leftOverFoodViewModel.fnameController.value,
            labelText: "Full Name",
            hintText: "Enter your full name",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                leftOverFoodViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText:
                leftOverFoodViewModel.errors.contains(AppColors.kNamelNullError)
                    ? AppColors.kNamelNullError
                    : null,
            validator: (value) {
              if (value!.isEmpty) {
                leftOverFoodViewModel.addError(
                    error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: leftOverFoodViewModel.phoneController.value,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: leftOverFoodViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => leftOverFoodViewModel.phone = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                leftOverFoodViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                leftOverFoodViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: leftOverFoodViewModel.addressController.value,
            labelText: "Address",
            hintText: "Enter your Address",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText: leftOverFoodViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                leftOverFoodViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                leftOverFoodViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: leftOverFoodViewModel.personNumberController.value,
            labelText: "For how many persons?",
            hintText: "Enter number of persons",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/persons.svg"),
            errorText: leftOverFoodViewModel.errors
                    .contains(AppColors.kPersonNullError)
                ? AppColors.kPersonNullError
                : null,
            // onSaved: (newValue) => leftOverFoodViewModel.persons = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                leftOverFoodViewModel.removeError(
                    error: AppColors.kPersonNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                leftOverFoodViewModel.addError(
                    error: AppColors.kPersonNullError);
                return AppColors.kPersonNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: leftOverFoodViewModel.detailsController.value,
            maxLines: 3,
            labelText: "Food Details",
            hintText: "Enter your Food Details",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Chat bubble Icon.svg"),
            errorText: leftOverFoodViewModel.errors
                    .contains(AppColors.kDetailsNullError)
                ? AppColors.kDetailsNullError
                : null,
            // onSaved: (newValue) => details = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                leftOverFoodViewModel.removeError(
                    error: AppColors.kDetailsNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                leftOverFoodViewModel.addError(
                    error: AppColors.kDetailsNullError);
                return AppColors.kDetailsNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          // FormError(errors: errors),
          const SizedBox(height: 50),

          leftOverFoodViewModel.loading.value
              ? CircularProgressIndicator()
              : CustomElevatedButton(
                  onPressed: () async {
                    if (leftOverFoodViewModel.formkey.value.currentState!
                        .validate()) {
                      leftOverFoodViewModel.formkey.value.currentState!.save();
                      await leftOverFoodViewModel.saveLeftoverFoodData();
                    }
                  },
                  text: 'Submit',
                ),
        ],
      ),
    );
  }

  // void _openMapToSelectLocation() async {
  //   // Navigate to map screen where user can select location
  //   LatLng? location = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const MapScreen(
  //         firstName: '',
  //         phoneNumber: '',
  //         details: '',
  //         persons: '',
  //         address: '',
  //       ),
  //     ),
  //   );

  //   if (location != null) {
  //     setState(() {
  //       selectedLocation = location;
  //     });
  //   }
  // }

  Future<void> saveDataAndNavigate() async {
    try {
      // Save data to Firebase
      String id = const Uuid().v4();
      // await saveDataToRealtimeDatabase(id);

      // Navigate to confirmation screen with all the data
      navigateToConfirmationScreen(id);
    } catch (error) {
      // Handle error
      print("Error saving data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving data. Please try again later.'),
        ),
      );
    }
  }

  // Future<void> saveDataToRealtimeDatabase(String id) async {
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     String userId = user.uid;
  //     String fName = FnameController.text.trim();
  //     String phone = PhoneController.text.trim();
  //     String address = addressController.text.trim();
  //     String persons = personNumberController.text.trim();
  //     String details = detialsController.text.trim();
  //     String selectedLocationString =
  //         "${_currentPosition!.latitude},${_currentPosition!.longitude}";

  //     DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //     await databaseReference.child('users').child(userId).child(id).set({
  //       "fName": fName,
  //       "phone": phone,
  //       "address": address,
  //       "persons": persons,
  //       "details": details,
  //       "location": selectedLocationString,
  //     });

  //     log("User data saved to Realtime Database");
  //   }
  // }

  void navigateToConfirmationScreen(String id) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => FoodConfirmationDetails(
    //       firstName: FnameController.text.trim(),
    //       phoneNumber: PhoneController.text.trim(),
    //       address: addressController.text.trim(),
    //       persons: personNumberController.text.trim(),
    //       details: detialsController.text.trim(),
    //       location:
    //           LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    //       id: id,
    //     ),
    //   ),
    // );
  }
}
