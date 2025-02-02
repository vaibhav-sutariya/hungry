import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/custom_suffix_icon.dart';
import 'package:hungry/view_models/controllers/login/login_view_model.dart';

class LoginForm extends StatefulWidget {
  final String buttonPressed;
  const LoginForm({super.key, required this.buttonPressed});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel = LoginViewModel();
    return Form(
      key: loginViewModel.formkey.value,
      child: Column(
        children: [
          TextFormField(
            controller: loginViewModel.emailController.value,
            keyboardType: TextInputType.emailAddress,
            // onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                loginViewModel.removeError(error: AppColors.kEmailNullError);
              } else if (AppColors.emailValidatorRegExp.hasMatch(value)) {
                loginViewModel.removeError(error: AppColors.kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                loginViewModel.addError(error: AppColors.kEmailNullError);
                return "Enter Email";
              } else if (!AppColors.emailValidatorRegExp.hasMatch(value)) {
                loginViewModel.addError(error: AppColors.kInvalidEmailError);
                return "Emter valid Email";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: loginViewModel.passwordController.value,
            obscureText: true,
            // onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                loginViewModel.removeError(error: AppColors.kPassNullError);
              } else if (value.length >= 8) {
                loginViewModel.removeError(error: AppColors.kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                loginViewModel.addError(error: AppColors.kPassNullError);
                return "Enter Valid Password";
              } else if (value.length < 8) {
                loginViewModel.addError(error: AppColors.kShortPassError);
                return "Enter Valid Password";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.kTextColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Obx(() {
                return Checkbox(
                  value: loginViewModel.remember.value,
                  activeColor: AppColors.kPrimaryColor,
                  onChanged: (value) {
                    loginViewModel.remember.value = value!;
                  },
                );
              }),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          // FormError(errors: errors),
          const SizedBox(height: 16),
          Obx(() {
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
                if (loginViewModel.formkey.value.currentState!.validate()) {
                  loginViewModel.formkey.value.currentState!.save();
                  loginViewModel.login();
                }
              },
              child: loginViewModel.loading.value
                  ? const CircularProgressIndicator() // Show loading indicator if isLoading is true
                  : const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            );
          })
        ],
      ),
    );
  }
}
