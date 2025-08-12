import 'package:benevolent_crm_app/app/modules/filters/modals/agents_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/sub_status_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class FiltersServices {
  final ApiClient _apiClient;

  FiltersServices({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

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

  Future<LeadStatusResponse> getStatuses(sourceRequest) async {
    try {
      final response = await _apiClient.get(ApiEndPoints.GET_STATUS);
      return LeadStatusResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<SourceResponse> getSources(SourceRequest sourceRequest) async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.GET_SOURCE,
        queryParameters: {"compaign_id": sourceRequest.compaignId},
      );
      print(response.data);
      return SourceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<SubStatusResponse> getSubStatus() async {
    try {
      final response = await _apiClient.get(
        ApiEndPoints.GET_SUB_STATUS,
        queryParameters: {"status_id": ""},
      );
      print('SubStatusResponse:');
      print(response.data);
      return SubStatusResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
