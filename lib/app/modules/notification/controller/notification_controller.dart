// controllers/notification_controller.dart
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/notification/models/notification_model.dart';
import 'package:benevolent_crm_app/app/modules/notification/models/delete_notifications_response.dart';
import 'package:benevolent_crm_app/app/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService;
  NotificationController({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  final notifications = <DeviceNotification>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final response = await _notificationService.fetchNotifications();
      notifications.assignAll(response.data);
      unreadCount.value =
          notifications.length; // replace with real unread logic if available
    } catch (e) {
      errorMessage.value = e.toString();
      notifications.clear();
      unreadCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() => fetchNotifications();

  /// Remove locally by ids (used for optimistic UI)
  void removeLocalByIds(List<int> ids) {
    notifications.removeWhere((n) => ids.contains(n.id));
    unreadCount.value = notifications.length;
  }

  /// Restore one locally at an index (for Undo)
  void restoreLocalAt(DeviceNotification item, int index) {
    if (index < 0 || index > notifications.length) {
      notifications.insert(0, item);
    } else {
      notifications.insert(index, item);
    }
    unreadCount.value = notifications.length;
  }

  /// Finalize deletion on server (used after Snackbar timeout)
  Future<DeleteNotificationsResponse> commitDelete(List<int> ids) async {
    final res = await _notificationService.deleteNotifications(ids);
    // you can use res.message if you want to toast something
    return res;
  }
}
