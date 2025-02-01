import 'package:flutter/material.dart';
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
              // if (value.isNotEmpty) {
              //   // removeError(error: AppColors.kEmailNullError);
              // } else if (AppColors.emailValidatorRegExp.hasMatch(value)) {
              //   // removeError(error: AppColors.kInvalidEmailError);
              // }
              return;
            },
            validator: (value) {
              // if (value!.isEmpty) {
              //   addError(error: AppColors.kEmailNullError);
              //   return "";
              // } else if (!emailValidatorRegExp.hasMatch(value)) {
              //   addError(error: AppColors.kInvalidEmailError);
              //   return "";
              // }
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
              // if (value.isNotEmpty) {
              //   removeError(error: AppColors.kPassNullError);
              // } else if (value.length >= 8) {
              //   removeError(error: AppColors.kShortPassError);
              // }
              return;
            },
            validator: (value) {
              // if (value!.isEmpty) {
              //   addError(error: kPassNullError);
              //   return "";
              // } else if (value.length < 8) {
              //   addError(error: kShortPassError);
              //   return "";
              // }
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
              Checkbox(
                value: loginViewModel.remember.value,
                activeColor: AppColors.kPrimaryColor,
                onChanged: (value) {
                  loginViewModel.remember.value = value!;
                },
              ),
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
                side:
                    const BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            ),
            onPressed: () {
              if (loginViewModel.formkey.value.currentState!.validate()) {
                loginViewModel.formkey.value.currentState!.save();
                // if all are valid then go to success screen
                // login();
              }
            },
            child: loginViewModel.loading.value
                ? const CircularProgressIndicator() // Show loading indicator if isLoading is true
                : const Text(
                    "Sign In",
                    style: TextStyle(
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
