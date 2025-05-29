import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view_models/controllers/add_foodbank/add_foodbank_view_model.dart';

class FoodBankDetailsForm extends StatelessWidget {
  FoodBankDetailsForm({super.key});

  final AddFoodbankViewModel addFoodbankViewModel =
      Get.put(AddFoodbankViewModel());
  @override
  Widget build(BuildContext context) {
    return Form(
      key: addFoodbankViewModel.formKey.value,
      child: Column(
        children: [
          CustomTextField(
            controller: addFoodbankViewModel.foodNGoNameController.value,
            labelText: "Food Bank or NGO Name",
            hintText: "Enter Food bank or NGO name",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/bank-outline.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText:
                addFoodbankViewModel.errors.contains(AppColors.kNamelNullError)
                    ? AppColors.kNamelNullError
                    : null,
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addFoodbankViewModel.fNameController.value,
            labelText: "Name of Head Person",
            hintText: "Enter Name of head person",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText:
                addFoodbankViewModel.errors.contains(AppColors.kNamelNullError)
                    ? AppColors.kNamelNullError
                    : null,
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addFoodbankViewModel.gmailController.value,
            labelText: "Gmail",
            hintText: "Enter your gmail",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            errorText: addFoodbankViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addFoodbankViewModel.phoneController.value,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: addFoodbankViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addFoodbankViewModel.volunteerController.value,
            labelText: "No. of Volunteers",
            hintText: "Enter no. of volunteers",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/persons.svg"),
            errorText: addFoodbankViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addFoodbankViewModel.addressController.value,
            labelText: "Address",
            hintText: "Enter your Address",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText: addFoodbankViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addFoodbankViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addFoodbankViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          // FormError(errors: errors),
          const SizedBox(height: 50),
          Obx(
            () => addFoodbankViewModel.loading.value
                ? CircularProgressIndicator(
                    color: AppColors.kPrimaryColor,
                  )
                : CustomElevatedButton(
                    onPressed: () async {
                      if (addFoodbankViewModel.formKey.value.currentState!
                          .validate()) {
                        // Save the form data
                        addFoodbankViewModel.formKey.value.currentState!.save();

                        Get.toNamed(RouteName.foodBankConfirmationScreen);
                      }
                    },
                    text: "Submit",
                  ),
          ),
        ],
      ),
    );
  }
}
