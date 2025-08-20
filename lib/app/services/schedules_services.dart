import 'package:benevolent_crm_app/app/modules/others/modals/create_schedule_response_model.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/delete_schedule_response_model.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/schedule_request_model.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/shedule_modal.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/update_schedule_response_model.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';

class SchedulesServices {
  final ApiClient _apiClient;

  SchedulesServices({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<SchedulesResponseModel> fetchSchedules(int id) async {
    try {
      final response = await _apiClient.get('/schedules/${id.toString()}');
      final jsonData = response.data;
      print(jsonData);
      print("schedules fetched successfully");
      return SchedulesResponseModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateScheduleResponseModel> addSchedules(
    ScheduleRequestModel sheduleRequestModal,
  ) async {
    print("helloeow wookdsd");

    print(sheduleRequestModal.toJson());
    print(sheduleRequestModal.leadId);
    try {
      final response = await _apiClient.post(
        '/add-schedule',
        data: sheduleRequestModal.toJson(),
      );
      print("response received");
      final jsonData = response.data;
      return CreateScheduleResponseModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateScheduleResponseModel> updateSchedules(
    int id,
    ScheduleRequestModel sheduleRequestModal,
  ) async {
    print(sheduleRequestModal.toJson());
    try {
      final response = await _apiClient.post(
        '/update-schedule/${id}',
        data: sheduleRequestModal.toJson(),
      );
      final jsonData = response.data;
      return UpdateScheduleResponseModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeleteScheduleResponseModel> deleteSchedules(int id) async {
    print("delete fired");
    try {
      final response = await _apiClient.post('/delete-schedule/${id}');
      final jsonData = response.data;
      return DeleteScheduleResponseModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }
}
