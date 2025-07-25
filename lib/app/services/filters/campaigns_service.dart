import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class CampaignsService {
  final ApiClient _apiClient;

  CampaignsService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<CampaignsResponse> getCampaigns() async {
    try {
      final response = await _apiClient.get(ApiEndPoints.GET_CAMPAIGNS);
      return CampaignsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
