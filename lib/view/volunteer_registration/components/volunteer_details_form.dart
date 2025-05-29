import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customElevatedButton.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/volunteer_registration/volunteer_registration_view_model.dart';
import 'package:intl/intl.dart';

class VolunteerDetailsForm extends StatefulWidget {
  const VolunteerDetailsForm({super.key});

  @override
  State<VolunteerDetailsForm> createState() => _VolunteerDetailsFormState();
}

class _VolunteerDetailsFormState extends State<VolunteerDetailsForm> {
  VolunteerRegistrationViewModel volunteerRegistrationViewModel = Get.put(
    VolunteerRegistrationViewModel(),
  );

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
            suffixIcon: const CustomSurffixIcon(
              svgIcon: "assets/icons/User.svg",
            ),
            // onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                  error: AppColors.kNamelNullError,
                );
              }
            },
            errorText: volunteerRegistrationViewModel.errors.contains(
              AppColors.kNamelNullError,
            )
                ? AppColors.kNamelNullError
                : null,
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                  error: AppColors.kNamelNullError,
                );
                return AppColors.kNamelNullError;
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      volunteerRegistrationViewModel.setDOB(pickedDate!);
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kPrimaryColor),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            volunteerRegistrationViewModel.selectedDOB != null
                                ? DateFormat('dd-MM-yyyy').format(
                                    volunteerRegistrationViewModel
                                            .selectedDOB.value ??
                                        DateTime.now(),
                                  )
                                : DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(DateTime.now()),
                            style: TextStyle(
                              color: AppColors.kTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.kPrimaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kPrimaryColor),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(
                      () => DropdownButton<String>(
                        value: volunteerRegistrationViewModel
                                .selectedGender.value.isNotEmpty
                            ? volunteerRegistrationViewModel
                                .selectedGender.value
                            : volunteerRegistrationViewModel.genderOptions[0],
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.kPrimaryColor,
                        ),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            volunteerRegistrationViewModel.setGender(newValue);
                          }
                        },
                        items:
                            volunteerRegistrationViewModel.genderOptions.map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.kTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: volunteerRegistrationViewModel.phoneController.value,
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            suffixIcon: const CustomSurffixIcon(
              svgIcon: "assets/icons/Phone.svg",
            ),
            errorText: volunteerRegistrationViewModel.errors.contains(
              AppColors.kPhoneNumberNullError,
            )
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => volunteerRegistrationViewModel.phone = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                  error: AppColors.kPhoneNumberNullError,
                );
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                  error: AppColors.kPhoneNumberNullError,
                );
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
            suffixIcon: const CustomSurffixIcon(
              svgIcon: "assets/icons/Phone.svg",
            ),
            errorText: volunteerRegistrationViewModel.errors.contains(
              AppColors.kPhoneNumberNullError,
            )
                ? AppColors.kPhoneNumberNullError
                : null,
            // onSaved: (newValue) => volunteerRegistrationViewModel.phone = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                  error: AppColors.kPhoneNumberNullError,
                );
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                  error: AppColors.kPhoneNumberNullError,
                );
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
              svgIcon: "assets/icons/Location point.svg",
            ),
            errorText: volunteerRegistrationViewModel.errors.contains(
              AppColors.kAddressNullError,
            )
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                  error: AppColors.kAddressNullError,
                );
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                  error: AppColors.kAddressNullError,
                );
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
              svgIcon: "assets/icons/Location point.svg",
            ),
            errorText: volunteerRegistrationViewModel.errors.contains(
              AppColors.kAddressNullError,
            )
                ? AppColors.kAddressNullError
                : null,
            // onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                volunteerRegistrationViewModel.removeError(
                  error: AppColors.kAddressNullError,
                );
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                volunteerRegistrationViewModel.addError(
                  error: AppColors.kAddressNullError,
                );
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
