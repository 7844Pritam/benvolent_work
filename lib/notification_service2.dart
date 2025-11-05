import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService2 {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsDarwin,
      macOS: initSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

    await _createNotificationChannel();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data['route'],
        );
      }
    });
  }

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

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'General',
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

  static void _handleNotificationClick(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Get.toNamed(payload);
    } else {
      Get.to(() => const SplashScreen());
    }
  }
}
