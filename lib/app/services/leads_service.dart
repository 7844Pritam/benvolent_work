import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class LeadsService {
  final ApiClient _apiClient;

  LeadsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LeadResponseModel> fetchLeads(LeadRequestModel requestModel) async {
    try {
      final response = await _apiClient.get(ApiEndPoints.LEADS_URL);
      return LeadResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
