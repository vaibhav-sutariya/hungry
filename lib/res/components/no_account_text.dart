// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:hungry/res/colors/app_colors.dart';

class NoAccountText extends StatelessWidget {
  final String buttonPressed;

  const NoAccountText({
    super.key,
    required this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (context) => SignUpScreen(
            //       buttonPressed: buttonPressed,
            //     ),
            //   ),
            // );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 16, color: AppColors.kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
