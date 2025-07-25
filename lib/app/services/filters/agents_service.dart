import 'package:benevolent_crm_app/app/modules/filters/modals/agents_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class AgentsService {
  final ApiClient _apiClient;

  AgentsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AgentsResponse> getAgents() async {
    try {
      final response = await _apiClient.get(ApiEndPoints.GET_AGENTS);
      return AgentsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
