import 'package:benevolent_crm_app/app/modules/dashboard/modals/dashboard_model.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class DashboardService {
  final ApiClient _apiClient;

  DashboardService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<DashboardModel> dashboardData() async {
    try {
      final response = await _apiClient.get(ApiEndPoints.DASHBOARD_URL);
      return DashboardModel.fromJson(response.data);
    } on DioException catch (e) {
      print("From dashboard servic" + e.toString());

      throw ErrorHandler.handle(e);
    } catch (e) {
      print("From dashboard servic" + e.toString());
      rethrow;
    }
  }
}
