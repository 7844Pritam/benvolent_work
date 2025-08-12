import 'package:benevolent_crm_app/app/modules/notification/models/delete_notifications_response.dart';
import 'package:benevolent_crm_app/app/modules/notification/models/notification_model.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<NotificationResponse> fetchNotifications() async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.GET_DEVICE_NOTIFICATIONS,
      );
      print("Response from fetchNotifications: ${response.data}");
      return NotificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeleteNotificationsResponse> deleteNotifications(List<int> ids) async {
    try {
      final payload = {
        "ids": ids.map((e) => e.toString()).join(','), // <- matches your cURL
      };
      final response = await _apiClient.post(
        ApiEndPoints.DELETE_DEVICE_NOTIFICATIONS,
        data: payload,
      );
      return DeleteNotificationsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
