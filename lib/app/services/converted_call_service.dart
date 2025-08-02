import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:dio/dio.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';

class ConvertedCallService {
  final ApiClient _apiClient;

  ConvertedCallService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<ConvertedCallResponse> fetchConvertedCalls({
    int page = 1,
    required LeadRequestModel requestModel,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.GET_COLD_CALLS_CONVERTS,
        queryParameters: {'page': page},
        data: requestModel,
      );
      return ConvertedCallResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
