import 'package:benevolent_crm_app/app/modules/auth/views/create_password_screen.dart';
import 'package:benevolent_crm_app/app/modules/auth/views/reset_password_screen.dart';
import 'package:benevolent_crm_app/app/modules/auth/views/verify_screen.dart';
import 'package:benevolent_crm_app/app/modules/dashboard/views/dashboard.dart';
import 'package:benevolent_crm_app/app/modules/profile/bindings/profile_binding.dart';

import 'package:benevolent_crm_app/app/modules/profile/view/profile_page_cards.dart';
import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:benevolent_crm_app/app/widgets/bottom_bar.dart';
import 'package:benevolent_crm_app/app/widgets/dummy_page.dart';
import 'package:get/get.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/signup_screen.dart';
import 'package:benevolent_crm_app/app/modules/campaign_summary/bindings/campaign_summary_binding.dart';
import 'package:benevolent_crm_app/app/modules/campaign_summary/views/campaign_summary_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.createPassword,
      page: () => const CreatePasswordScreen(email: '', flag: 0),
    ),
    GetPage(
      name: AppRoutes.verify,
      page: () => const VerifyScreen(email: ''),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(name: AppRoutes.dashboard, page: () => Dashboard()),
    GetPage(
      name: '/home',
      page: () => DummyPage(title: 'Home', index: 0),
    ),
    GetPage(
      name: '/mail',
      page: () => DummyPage(title: 'Mail', index: 1),
    ),
    GetPage(
      name: '/tasks',
      page: () => DummyPage(title: 'Tasks', index: 2),
    ),
    GetPage(
      name: '/shipping',
      page: () => DummyPage(title: 'Shipping', index: 3),
    ),
    GetPage(
      name: '/about',
      page: () => DummyPage(title: 'About', index: 4),
    ),
    GetPage(name: '/bottombar', page: () => CustomBottomBar()),
    GetPage(name: '/profile', page: () => UserProfileCard()),
    GetPage(
      name: AppRoutes.campaignSummary,
      page: () => const CampaignSummaryView(),
      binding: CampaignSummaryBinding(),
    ),
  ];
}
