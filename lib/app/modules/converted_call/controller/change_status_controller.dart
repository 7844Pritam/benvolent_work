import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/services/change_status_service.dart';

import 'package:get/get.dart';

class ChangeStatusController extends GetxController {
  final ChangeStatusService _service = ChangeStatusService();

  RxList<ConvertedCall> calls = <ConvertedCall>[].obs;

  void changeStatus(
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
      if (res['success'] == true) {
        Get.snackbar("Success", "Status updated successfully");
      } else {
        Get.snackbar("Error", res['message'] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
