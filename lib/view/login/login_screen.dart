import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/res/components/no_account_text.dart';
import 'package:hungry/res/components/socal_card.dart';
import 'package:hungry/view/login/components/login_form.dart';
import 'package:hungry/view_models/controllers/login_with_google/sign_in_with_google.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.buttonPressed,
  });
  final String buttonPressed;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final SignInWithGoogle signInWithGoogle = SignInWithGoogle();
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(
        showLogOut: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in with your email and password\nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  LoginForm(buttonPressed: widget.buttonPressed),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("  OR  "),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return signInWithGoogle.loading.value
                            ? const CircularProgressIndicator(
                                color: AppColors.kPrimaryColor,
                              )
                            : SocalCard(
                                icon: "assets/icons/google-icon.svg",
                                press: () async {
                                  signInWithGoogle.signInWithGoogle();
                                  // await signInWithGoogle();
                                  // if (userCredential.value != null) {
                                  //   print(userCredential.value!.user!.email);
                                  //   switch (widget.buttonPressed) {
                                  //     case "Submit Remaining Food":
                                  //       // Navigator.pushReplacement(
                                  //       //   context,
                                  //       //   CupertinoPageRoute(
                                  //       //     builder: (context) =>
                                  //       //         const AddFoodDetails(),
                                  //       //   ),
                                  //       // );
                                  //       break;
                                  //     case "Add more Locations":
                                  //       // Navigator.pushReplacement(
                                  //       //   context,
                                  //       //   CupertinoPageRoute(
                                  //       //     builder: (context) =>
                                  //       //         const AddLocationDetails(),
                                  //       //   ),
                                  //       // );
                                  //       break;
                                  //     case "Register Food Center":
                                  //       // Navigator.pushReplacement(
                                  //       //   context,
                                  //       //   CupertinoPageRoute(
                                  //       //     builder: (context) =>
                                  //       //         const AddFoodBankDetails(),
                                  //       //   ),
                                  //       // );
                                  //       break;
                                  //     case "Login":
                                  //       // Navigator.pushReplacement(
                                  //       //   context,
                                  //       //   CupertinoPageRoute(
                                  //       //     builder: (context) =>
                                  //       //         const InitScreen(),
                                  //       //   ),
                                  //       // );
                                  //       break;
                                  //     default:
                                  //       // Navigate to a default screen if buttonPressed is not recognized
                                  //       break;
                                  //   }
                                  // }
                                  // print(widget.buttonPressed);
                                },
                              );
                      })
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NoAccountText(
                    buttonPressed: 'Sign In',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
