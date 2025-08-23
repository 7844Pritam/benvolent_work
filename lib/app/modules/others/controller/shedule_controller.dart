import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/shedule_modal.dart';

import 'package:benevolent_crm_app/app/modules/others/modals/schedule_request_model.dart';
import 'package:benevolent_crm_app/app/services/schedules_services.dart';

class ScheduleController extends GetxController {
  final SchedulesServices _scheduleService = SchedulesServices();

  RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  Future<void> loadSchedules(int leadId) async {
    try {
      isLoading.value = true;
      final result = await _scheduleService.fetchSchedules(leadId);
      schedules.value = result.data;
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSchedule(ScheduleRequestModel request) async {
    try {
      isSubmitting.value = true;
      final result = await _scheduleService.addSchedules(request);
      schedules.add(ScheduleModel.fromJson(result.data.toJson()));
      print("Schedule added successfully");
      print(result.message);
      Get.back();
      await Future.delayed(Duration(milliseconds: 300));
      CustomSnackbar.show(title: "Success", message: result.message);
    } catch (e) {
      print(e);
      CustomSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateSchedule(int id, ScheduleRequestModel request) async {
    print(request.toJson());
    print(id);
    try {
      isSubmitting.value = true;
      final result = await _scheduleService.updateSchedules(id, request);
      final updated = result.data;

      final index = schedules.indexWhere((s) => s.id == updated.id);
      if (index != -1) {
        schedules[index] = ScheduleModel.fromJson(updated.toJson());
        schedules.refresh();
      }
      Get.back();
      await Future.delayed(Duration(milliseconds: 300));
      CustomSnackbar.show(title: "Success", message: result.message);
    } catch (e) {
      print(e.toString());
      CustomSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteSchedule(int id) async {
    try {
      isSubmitting.value = true;
      final result = await _scheduleService.deleteSchedules(id);

      schedules.removeWhere((s) => s.id == id);
      CustomSnackbar.show(title: "Success", message: result.message);
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
