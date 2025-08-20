import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/services/change_status_service.dart';

import 'package:get/get.dart';

class ChangeStatusController extends GetxController {
  final ChangeStatusService _service = ChangeStatusService();
  final LeadsController _leadsController = Get.find<LeadsController>();
  RxList<ConvertedCall> calls = <ConvertedCall>[].obs;

  Future<void> changeStatus(
    int id,
    String status,
    String subStatus,
    String comment,
  ) async {
    try {
      final res = await _service.changeStatus(
        id: id,
        status: status,
        subStatus: subStatus,
        comment: comment,
      );

      if (res['success'] == 200) {
        print("Status updated successfully");

        Get.snackbar("Success", "Status updated successfully");

        print("Status updated successfully234");

        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          }
        });
      } else {
        Get.snackbar("Error", res['message'] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
