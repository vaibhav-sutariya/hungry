import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/add_locations/add_location_screen.dart';
import 'package:hungry/view/bottom_bar.dart';
import 'package:hungry/view/donations/donation_screen.dart';
import 'package:hungry/view/find_food/find_food_screen.dart';
import 'package:hungry/view/find_food/see_all_location/see_all_screen.dart';
import 'package:hungry/view/food_bank/food_bank_confirmation_screen.dart';
import 'package:hungry/view/food_bank/food_bank_screen.dart';
import 'package:hungry/view/home/home_screen.dart';
import 'package:hungry/view/leftover_food/submit_leftover_food_screen.dart';
import 'package:hungry/view/login/login_screen.dart';
import 'package:hungry/view/pages/about_us.dart';
import 'package:hungry/view/pages/contact_us.dart';
import 'package:hungry/view/pages/help_center.dart';
import 'package:hungry/view/pages/setting_privacy.dart';
import 'package:hungry/view/profile/profile_screen.dart';
import 'package:hungry/view/search/search_screen.dart';
import 'package:hungry/view/signup/sign_up_screen.dart';
import 'package:hungry/view/splash_screen.dart';
import 'package:hungry/view/view_details/view_details_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.bottomBar,
          page: () => BottomBar(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.aboutUsScreen,
          page: () => const AboutUsScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.contactUsScreen,
          page: () => const ContactUsScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.helpCenterScreen,
          page: () => const HelpCenterScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.settingPrivacyScreen,
          page: () => const SettingsPrivacyScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.searchScreen,
          page: () => const SearchScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => const LoginScreen(
            buttonPressed: 'intial',
          ),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.signUpScreen,
          page: () => const SignUpScreen(
            buttonPressed: 'intial',
          ),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.findFoodScreen,
          page: () => const FindFoodScreen(),
          transition: Transition.downToUp,
          transitionDuration: const Duration(
            milliseconds: 700,
          ),
        ),
        GetPage(
          name: RouteName.seeAllScreen,
          page: () => const SeeAllScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.submitLeftoverFoodScreen,
          page: () => const SubmitLeftoverFoodScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.viewDetailsScreen,
          page: () => const ViewDetailsScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.profileScreen,
          page: () => const ProfileScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.donationScreen,
          page: () => const DonationScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        // GetPage(
        //   name: RouteName.foodConfirmationScreen,
        //   page: () => const FoodConfirmationScreen(
        //     firstName: '',
        //     phoneNumber: '',
        //     address: '',
        //     details: '',
        //     persons: '',
        //     id: '',
        //   ),
        //   transition: Transition.rightToLeft,
        //   transitionDuration: const Duration(
        //     milliseconds: 250,
        //   ),
        // ),
        GetPage(
          name: RouteName.addLocationScreen,
          page: () => const AddLocationScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.foodBankScreen,
          page: () => const FoodBankScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
        GetPage(
          name: RouteName.foodBankConfirmationScreen,
          page: () => FoodBankConfirmationScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(
            milliseconds: 250,
          ),
        ),
      ];
}
