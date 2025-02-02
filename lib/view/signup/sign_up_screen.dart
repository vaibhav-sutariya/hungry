// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hungry/res/colors/app_colors.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/res/components/socal_card.dart';
import 'package:hungry/view/signup/components/sign_up_form.dart';
import 'package:hungry/view_models/controllers/login_with_google/sign_in_with_google.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.buttonPressed,
  });
  final String buttonPressed;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignInWithGoogle signInWithGoogle = SignInWithGoogle();
  @override
  Widget build(BuildContext context) {
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
                  const Text("Register Account", style: AppColors.headingStyle),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SignUpForm(),
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
                      signInWithGoogle.loading.value
                          ? const CircularProgressIndicator()
                          : SocalCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () async {
                                signInWithGoogle.signInWithGoogle();
                                // Check if userCredential is not null after authentication
                                // if (userCredential.value != null) {
                                //   print(userCredential.value!.user!.email);
                                //   switch (widget.buttonPressed) {
                                //     case "Submit Remaining Food":
                                // Navigator.pushReplacement(
                                //   context,
                                //   CupertinoPageRoute(
                                //     builder: (context) =>
                                //         const AddFoodDetails(),
                                //   ),
                                // );
                                //   break;
                                // case "Add more Locations":
                                // Navigator.pushReplacement(
                                //   context,
                                //   CupertinoPageRoute(
                                //     builder: (context) =>
                                //         const AddLocationDetails(),
                                //   ),
                                // );
                                //   break;
                                // case "Register Food Center":
                                // Navigator.pushReplacement(
                                //   context,
                                //   CupertinoPageRoute(
                                //     builder: (context) =>
                                //         const AddFoodBankDetails(),
                                //   ),
                                // );
                                // break;
                                // case "Sign In":
                                // Navigator.pushReplacement(
                                //   context,
                                //   CupertinoPageRoute(
                                //     builder: (context) =>
                                //         const InitScreen(),
                                //   ),
                                // );
                                // break;
                                // default:
                                // Navigate to a default screen if buttonPressed is not recognized
                                // break;
                                // }
                                // }
                                // print(widget.buttonPressed);
                              },
                            ),
                      // SocalCard(
                      //   icon: "assets/icons/facebook-2.svg",
                      //   press: () {},
                      // ),
                      // SocalCard(
                      //   icon: "assets/icons/twitter.svg",
                      //   press: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
