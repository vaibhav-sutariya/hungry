import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/home/home_screen.dart';
import 'package:hungry/view/login/login_screen.dart';
import 'package:hungry/view/pages/about_us.dart';
import 'package:hungry/view/pages/contact_us.dart';
import 'package:hungry/view/pages/help_center.dart';
import 'package:hungry/view/pages/setting_privacy.dart';
import 'package:hungry/view/signup/sign_up_screen.dart';
import 'package:hungry/view/splash_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.aboutUsScreen,
          page: () => const AboutUsScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.contactUsScreen,
          page: () => const ContactUsScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.helpCenterScreen,
          page: () => const HelpCenterScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.settingPrivacyScreen,
          page: () => const SettingsPrivacyScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => const LoginScreen(
            buttonPressed: 'intial',
          ),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.signUpScreen,
          page: () => const SignUpScreen(
            buttonPressed: 'intial',
          ),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        // GetPage(
        //   name: RouteName.HomeView,
        //   page: () => const HomeView(),
        //   transition: Transition.leftToRightWithFade,
        //   transitionDuration: const Duration(
        //     milliseconds: 250,
        //   ),
        // ),
      ];
}
