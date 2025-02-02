// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/customTextField.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/signup/singup_view_model.dart';

class SignUpForm extends StatefulWidget {
  final String buttonPressed;
  const SignUpForm({
    super.key,
    required this.buttonPressed,
  });
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    SingupViewModel singupViewModel = SingupViewModel();
    // String email = singupViewModel.emailController.value.text.trim();
    String password = singupViewModel.passwordController.value.text.trim();
    String confirmPassword =
        singupViewModel.cPasswordController.value.text.trim();

    return Form(
      key: singupViewModel.formkey.value,
      child: Column(
        children: [
          CustomTextField(
            controller: singupViewModel.emailController.value,
            labelText: 'Email',
            hintText: 'Enter your email',
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            onChanged: (value) {
              if (value.isNotEmpty) {
                singupViewModel.removeError(error: AppColors.kEmailNullError);
              } else if (AppColors.emailValidatorRegExp.hasMatch(value)) {
                singupViewModel.removeError(
                    error: AppColors.kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                singupViewModel.addError(error: AppColors.kEmailNullError);
                return "Enter Valid Email";
              } else if (!AppColors.emailValidatorRegExp.hasMatch(value)) {
                singupViewModel.addError(error: AppColors.kInvalidEmailError);
                return "Enter Valid Email";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: singupViewModel.passwordController.value,
            labelText: 'Password',
            hintText: 'Enter your password',
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            onChanged: (value) {
              if (value.isNotEmpty) {
                singupViewModel.removeError(error: AppColors.kPassNullError);
              } else if (value.length >= 8) {
                singupViewModel.removeError(error: AppColors.kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                singupViewModel.addError(error: AppColors.kPassNullError);
                return "Enter Valid Password";
              } else if (value.length < 8) {
                singupViewModel.addError(error: AppColors.kShortPassError);
                return "Enter Valid Password";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: singupViewModel.cPasswordController.value,
            labelText: "Confirm Password",
            hintText: "Re-enter your password",
            suffixIcon:
                const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            onChanged: (value) {
              if (value.isNotEmpty) {
                singupViewModel.removeError(error: AppColors.kPassNullError);
              } else if (value.isNotEmpty && password == confirmPassword) {
                singupViewModel.removeError(error: AppColors.kMatchPassError);
              }
              confirmPassword = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                singupViewModel.addError(error: AppColors.kPassNullError);
                return "Enter Valid Password";
              } else if ((password != value)) {
                singupViewModel.addError(error: AppColors.kMatchPassError);
                return "Enter Valid Password";
              }
              return null;
            },
          ),
          // FormError(errors: errors),
          const SizedBox(height: 20),

          Obx(
            () {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                    side: const BorderSide(
                        color: AppColors.kPrimaryColor, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                ),
                onPressed: () {
                  if (singupViewModel.formkey.value.currentState!.validate()) {
                    singupViewModel.formkey.value.currentState!.save();
                    singupViewModel.signUp();
                  }
                },
                child: singupViewModel.loading.value
                    ? const CircularProgressIndicator(
                        color: AppColors.kPrimaryColor,
                      ) // Show loading indicator if isLoading is true
                    : const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
