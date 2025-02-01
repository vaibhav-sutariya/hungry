import 'package:get/get.dart';
import 'package:hungry/res/routes/routes_name.dart';
import 'package:hungry/view/home/home_screen.dart';
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
        // GetPage(
        //   name: RouteName.LoginView,
        //   page: () => const LoginView(),
        //   transition: Transition.leftToRightWithFade,
        //   transitionDuration: const Duration(
        //     milliseconds: 250,
        //   ),
        // ),
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
