import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:get/get.dart';
import '../modules/auth/views/create_password_screen.dart';
import '../modules/auth/views/verify_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/signup_screen.dart';
import '../modules/auth/views/reset_password_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    // GetPage(
    //   name: AppRoutes.createPassword,
    //   page: () => const CreatePasswordScreen(),
    // ),
    // GetPage(name: AppRoutes.verify, page: () => const VerifyScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    // GetPage(
    //   name: AppRoutes.resetPassword,
    //   page: () => const ResetPasswordScreen(),
    // ),
  ];
}
