import 'package:benevolent_crm_app/app/modules/others/modals/lead_details_response.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class LeadsService {
  final ApiClient _apiClient;

  LeadsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LeadsResponse> fetchLeads({
    required LeadRequestModel requestModel,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.LEADS_URL,
        queryParameters: {'page': page},
        data: requestModel.toJson(),
      );
      print("Response from fetchLeads121212: ${response.data}");
      return LeadsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<LeadDetailsResponse> fetchLeadById(int id) async {
    try {
      final res = await _apiClient.get(ApiEndPoints.getLeadById(id));
      return LeadDetailsResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<LeadDetailsResponse> updateAdditionalPhone({
    required int leadId,
    required String additionalPhone,
  }) async {
    final resp = await _apiClient.post(
      '/lead_update_additional_phone/$leadId',
      data: {'additional_phone': additionalPhone},
    );

    if (resp.statusCode == 200) {
      return LeadDetailsResponse.fromJson(resp.data);
    }
    throw DioException(
      requestOptions: resp.requestOptions,
      response: resp,
      type: DioExceptionType.badResponse,
      error: 'Failed to update additional phone',
    );
  }
}
