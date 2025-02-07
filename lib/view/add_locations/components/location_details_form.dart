import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/add_location/add_location_view_model.dart';

class LocationDetailsForm extends StatefulWidget {
  const LocationDetailsForm({super.key});

  @override
  State<LocationDetailsForm> createState() => _LocationDetailsFormState();
}

class _LocationDetailsFormState extends State<LocationDetailsForm> {
  AddLocationViewModel addLocationViewModel = Get.put(AddLocationViewModel());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addLocationViewModel.formkey.value,
      child: Column(
        children: [
          CustomTextField(
            controller: addLocationViewModel.fnameController.value,
            labelText: "Full Name",
            hintText: "Enter your full name",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addLocationViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText:
                addLocationViewModel.errors.contains(AppColors.kNamelNullError)
                    ? AppColors.kNamelNullError
                    : null,
            validator: (value) {
              if (value!.isEmpty) {
                addLocationViewModel.addError(error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addLocationViewModel.phoneController.value,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: addLocationViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addLocationViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addLocationViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addLocationViewModel.addressController.value,
            labelText: "Address",
            hintText: "Enter your Address",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText: addLocationViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => addLocationViewModel.address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addLocationViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addLocationViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: addLocationViewModel.detailsController.value,
            maxLines: 3,
            labelText: "Details",
            hintText: "Enter your Details",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Chat bubble Icon.svg"),
            errorText: addLocationViewModel.errors
                    .contains(AppColors.kDetailsNullError)
                ? AppColors.kDetailsNullError
                : null,
            // onSaved: (newValue) => details = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                addLocationViewModel.removeError(
                    error: AppColors.kDetailsNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addLocationViewModel.addError(
                    error: AppColors.kDetailsNullError);
                return AppColors.kDetailsNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children:
                    addLocationViewModel.categories.keys.map((String key) {
                  return CheckboxListTile(
                    fillColor: WidgetStateProperty.all(AppColors.kPrimaryColor),
                    title: Text(key),
                    value: addLocationViewModel.categories[key],
                    onChanged: (bool? value) {
                      addLocationViewModel.toggleCategorySelection(key, value);
                    },
                  );
                }).toList(),
              )),
          const SizedBox(height: 20),
          Obx(() => addLocationViewModel.loading.value
              ? const CircularProgressIndicator()
              : CustomElevatedButton(
                  onPressed: () async {
                    if (addLocationViewModel.formkey.value.currentState!
                        .validate()) {
                      await addLocationViewModel.saveLocationData();
                    }
                  },
                  text: "Submit",
                )),

          // FormError(errors: errors),
        ],
      ),
    );
  }
}
