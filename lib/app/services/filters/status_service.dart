import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class StatusService {
  final ApiClient _apiClient;

  StatusService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LeadStatusResponse> getStatuses() async {
    try {
      final response = await _apiClient.get(ApiEndPoints.GET_STATUS);
      return LeadStatusResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
