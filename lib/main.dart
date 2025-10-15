import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/network_controller.dart';
import 'package:benevolent_crm_app/notification_service2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/themes/app_themes.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.messageId}");
  print("Data: ${message.data}");
  print("Notification: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Init local notifications (your custom service)
  await NotificationService2.init();

  // GetX Controllers
  Get.put(NetworkController(), permanent: true);
  Get.put(AuthController());
  // Get.put(ProfileController());

  // Init FCM
  await _initFCM();

  runApp(const MyApp());
}

Future<void> _initFCM() async {
  try {
    // Ask permission (iOS)
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Register background handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground message received:");
        print("Data: ${message.data}");
        print("Notification: ${message.notification?.title}");

        // Optional: show local notification
        NotificationService2.showNotification(
          title: message.notification?.title ?? "New Notification",
          body: message.notification?.body ?? "",
        );
      });

      // User taps a notification (when app in background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("📲 App opened from background by notification");
        print("Data: ${message.data}");
      });

      // Terminated state (when app starts from notification)
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        print("🚀 App launched by notification");
        print("Data: ${initialMessage.data}");
      }

      // Get APNs + FCM token
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print("🍏 APNs Token: $apnsToken");

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("🔥 FCM Token: $fcmToken");

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print("♻️ FCM Token refreshed: $newToken");
      });
    } else {
      print("❌ User declined notifications");
    }
  } catch (e) {
    print("⚠️ Error initializing FCM: $e");
  }
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
