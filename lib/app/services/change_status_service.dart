import 'package:benevolent_crm_app/app/services/api/api_client.dart';

class ChangeStatusService {
  final ApiClient _apiClient;

  ChangeStatusService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> changeStatus({
    required int id,
    required String status,
    required String subStatus,
    required String comment,
  }) async {
    final response = await _apiClient.post(
      '/change-status/$id',
      data: {"status": status, "sub_status": subStatus, "comment": comment},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to change status');
    }
  }
}
