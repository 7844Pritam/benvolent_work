import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService2 {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notification plugin + setup FCM foreground handler
  static Future<void> init() async {
    // 🔹 Android initialization
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 🔹 iOS / macOS initialization
    const DarwinInitializationSettings initSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // 🔹 Combined initialization
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsDarwin,
      macOS: initSettingsDarwin,
    );

    // 🔹 Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationClick(response.payload);
      },
    );

    // 🔹 Create Android notification channel
    await _createNotificationChannel();

    // 🔹 Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data['route'], // Optional: pass navigation route
        );
      }
    });
  }

  /// Show a local notification
  static Future<void> showNotification({
    required String? title,
    required String? body,
    String? payload,
  }) async {
    await _notificationsPlugin.show(
      0,
      title ?? "New Notification",
      body ?? "",
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'default_channel',
          'General',
          channelDescription: 'General notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Create Android notification channel (needed for >= Android 8.0)
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // id
      'General', // name
      description: 'General notifications',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification click → navigate inside app
  static void _handleNotificationClick(String? payload) {
    // Example: navigate to splash screen or use payload for routing
    if (payload != null && payload.isNotEmpty) {
      // If payload contains route name, use it
      Get.toNamed(payload);
    } else {
      // Default → splash screen
      Get.to(() => const SplashScreen());
    }
  }
}
