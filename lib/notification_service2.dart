import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService2 {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS / macOS settings (Darwin)
    const DarwinInitializationSettings initSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          // onDidReceiveLocalNotification: (id, title, body, payload) async {},
        );

    // Combined settings
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsDarwin,
      macOS: initSettingsDarwin,
    );

    // Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        Get.to(SplashScreen());
      },
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _notificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
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
        );
      }
    });
  }
}
