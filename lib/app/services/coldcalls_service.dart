import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';

class ColdCallService {
  final ApiClient _apiClient;

  ColdCallService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();
  Future<ColdCallResponse> fetchColdCalls(
    int page, {
    required LeadRequestModel requestModel,
  }) async {
    final response = await _apiClient.get(
      '/coldCalls',
      queryParameters: {'page': page},
      data: requestModel,
    );
    print("coldcalls");
    print(response);
    if (response.statusCode == 200) {
      return ColdCallResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load cold calls');
    }
  }
}
