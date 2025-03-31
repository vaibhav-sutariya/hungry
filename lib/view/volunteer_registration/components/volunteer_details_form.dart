import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/volunteer_registration/volunteer_registration_view_model.dart';

class VolunteerDetailsForm extends StatefulWidget {
  const VolunteerDetailsForm({super.key});

  @override
  State<VolunteerDetailsForm> createState() => _VolunteerDetailsFormState();
}

class _VolunteerDetailsFormState extends State<VolunteerDetailsForm> {
  VolunteerRegistrationViewModel volunteerRegistrationViewModel =
      Get.put(VolunteerRegistrationViewModel());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: volunteerRegistrationViewModel.formkey.value,
      child: Column(
        children: [
          CustomTextField(
            controller: volunteerRegistrationViewModel.fnameController.value,
            labelText: "Full Name",
            hintText: "Enter your full name",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kNamelNullError)
                ? AppColors.kNamelNullError
                : null,
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.dobController.value,
            labelText: "DOB",
            hintText: "Enter your DOB",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kNamelNullError)
                ? AppColors.kNamelNullError
                : null,
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.genderController.value,
            labelText: "Gender",
            hintText: "Enter your Gender",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kNamelNullError);
              }
            },
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kNamelNullError)
                ? AppColors.kNamelNullError
                : null,
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kNamelNullError);
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.phoneController.value,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => volunteerRegistrationViewModel.phone = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.emailController.value,
            labelText: "Email Address",
            hintText: "Enter your email address",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kPhoneNumberNullError)
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => volunteerRegistrationViewModel.phone = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kPhoneNumberNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kPhoneNumberNullError);
                return AppColors.kPhoneNumberNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.addressController.value,
            labelText: "Address",
            hintText: "Enter your Address",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.reasonController.value,
            labelText: "Why do you want to be a volunteer?",
            hintText: "Enter reson",
            suffixIcon: const CustomSurffixIcon(
                svgIcon: "assets/icons/Location point.svg"),
            errorText: volunteerRegistrationViewModel.errors
                    .contains(AppColors.kAddressNullError)
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                    error: AppColors.kAddressNullError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                    error: AppColors.kAddressNullError);
                return AppColors.kAddressNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          Obx(
            () => volunteerRegistrationViewModel.loading.value
                ? const CircularProgressIndicator(
                    color: AppColors.kPrimaryColor,
                  )
                : CustomElevatedButton(
                    onPressed: () async {
                      if (volunteerRegistrationViewModel
                          .formkey.value.currentState!
                          .validate()) {
                        await volunteerRegistrationViewModel
                            .saveVolunteerData();
                      }
                    },
                    text: 'Submit',
                  ),
          ),
        ],
      ),
    );
  }
}
