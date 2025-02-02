// import 'package:flutter/material.dart';
// import 'package:hungry/res/colors/app_colors.dart';
// import 'package:hungry/res/components/custom_suffix_icon.dart';

// class SignUpForm extends StatefulWidget {
//   const SignUpForm({super.key});

//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }

// class _SignUpFormState extends State<SignUpForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: emailController,
//             keyboardType: TextInputType.emailAddress,
//             onSaved: (newValue) => email = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: AppColors.kEmailNullError);
//               } else if (emailValidatorRegExp.hasMatch(value)) {
//                 removeError(error: AppColors.kInvalidEmailError);
//               }
//               return;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: AppColors.kEmailNullError);
//                 return "";
//               } else if (!emailValidatorRegExp.hasMatch(value)) {
//                 addError(error: AppColors.kInvalidEmailError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               labelText: "Email",
//               hintText: "Enter your email",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon:
//                   const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(color: AppColors.kTextColor),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             controller: passwordController,
//             obscureText: true,
//             onSaved: (newValue) => password = newValue,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 removeError(error: AppColors.kPassNullError);
//               } else if (value.length >= 8) {
//                 removeError(error: AppColors.kShortPassError);
//               }
//               password = value;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 addError(error: AppColors.kPassNullError);
//                 return "";
//               } else if (value.length < 8) {
//                 addError(error: AppColors.kShortPassError);
//                 return "";
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               labelText: "Password",
//               hintText: "Enter your password",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon:
//                   const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(color: AppColors.kTextColor),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextFormField(
//             controller: cPasswordController,
//             obscureText: true,
//             onSaved: (newValue) => conform_password = newValue,
//             onChanged: (value) {
//               //   if (value.isNotEmpty) {
//               //     removeError(error: AppColors.kPassNullError);
//               //   } else if (value.isNotEmpty && password == conform_password) {
//               //     removeError(error: AppColors.kMatchPassError);
//               //   }
//               //   conform_password = value;
//               // },
//               // validator: (value) {
//               //   if (value!.isEmpty) {
//               //     addError(error: AppColors.kPassNullError);
//               //     return "";
//               //   } else if ((password != value)) {
//               //     addError(error: AppColors.kMatchPassError);
//               //     return "";
//               //   }
//               return;
//             },
//             decoration: InputDecoration(
//               labelText: "Confirm Password",
//               hintText: "Re-enter your password",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon:
//                   const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(color: AppColors.kTextColor),
//               ),
//             ),
//           ),
//           // FormError(errors: errors),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12), // <-- Radius
//                 side:
//                     const BorderSide(color: AppColors.kPrimaryColor, width: 2),
//               ),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
//             ),
//             onPressed: isLoading
//                 ? null // Disable button when isLoading is true
//                 : () {
//                     if (_formKey.currentState!.validate()) {
//                       _formKey.currentState!.save();
//                       createAccount();
//                     }
//                   },
//             child: isLoading
//                 ? const CircularProgressIndicator() // Show loading indicator if isLoading is true
//                 : const Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       color: AppColors.kPrimaryColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
