import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class SourceService {
  final ApiClient _apiClient;

  SourceService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<SourceResponse> getStatuses(SourceRequest sourceRequest) async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.GET_SOURCE,
        queryParameters: {"compaign_id": ""},
      );
      return SourceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
