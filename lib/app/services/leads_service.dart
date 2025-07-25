import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';

class LeadsService {
  final ApiClient _apiClient;

  LeadsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LeadResponseModel> fetchLeads(LeadRequestModel requestModel) async {
    final response = await _apiClient.post(
      ApiEndPoints.LEADS_URL,
      data: requestModel.toJson(),
    );
    return LeadResponseModel.fromJson(response.data);
  }
}
