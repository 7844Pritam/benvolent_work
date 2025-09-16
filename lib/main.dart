import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:benevolent_crm_app/network_controller.dart';
import 'package:benevolent_crm_app/notification_service2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/themes/app_themes.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService2.init();
  Get.put(NetworkController(), permanent: true);
  Get.put(AuthController());
  Get.put(ProfileController(), permanent: true);

  runApp(const MyApp());

  // ✅ Request token after app is up
  _initFCM();
}

Future<void> _initFCM() async {
  try {
    // Try to get the initial token
    String? token = await FirebaseMessaging.instance.getToken();
    print('🔥 Initial FCM Token: $token');
  } catch (e) {
    print('❌ Error fetching initial FCM token: $e');
  }

  // Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print('♻️ FCM Token refreshed: $newToken');
    // Save to backend or local storage
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
