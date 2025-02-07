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

          Obx(() => leftOverFoodViewModel.loading.value
              ? const CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                )
              : CustomElevatedButton(
                  onPressed: () async {
                    if (leftOverFoodViewModel.formkey.value.currentState!
                        .validate()) {
                      await leftOverFoodViewModel.saveLeftoverFoodData();
                    }
                  },
                  text: 'Submit',
                )),
        ],
      ),
    );
  }
}
