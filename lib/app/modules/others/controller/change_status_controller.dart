import 'package:benevolent_crm_app/app/modules/converted_call/controller/converted_call_controller.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/modules/others/controller/lead_details_controller.dart';
import 'package:benevolent_crm_app/app/services/change_status_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class ChangeStatusController extends GetxController {
  final ChangeStatusService _service = ChangeStatusService();
  final LeadsController _leadsController = Get.find<LeadsController>();
  final ConvertedCallController _convertLeadsController =
      Get.find<ConvertedCallController>();
  RxList<ConvertedCall> calls = <ConvertedCall>[].obs;
  final isLoading = false.obs;
  final LeadDetailsController _leadDetailsController =
      Get.find<LeadDetailsController>();
  Future<void> changeStatus(
    int id,
    String status,
    String subStatus,
    String comment,
  ) async {
    try {
      isLoading.value = true;
      final res = await _service.changeStatus(
        id: id,
        status: status,
        subStatus: subStatus,
        comment: comment,
      );

      if (res['success'] == 200) {
        final statusName =
            Get.find<FiltersController>().statusList
                .firstWhereOrNull((s) => s.id.toString() == status)
                ?.name ??
            'Unknown';
        _leadsController.updateLeadStatus(
          leadId: id,
          statusId: int.parse(status),
          statusName: statusName,
        );
        _convertLeadsController.updateLeadStatus(
          leadId: id,
          statusId: int.parse(status),
          statusName: statusName,
        );

        // Close the bottom sheet first
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        _leadDetailsController.updateLeadStatus(
          statusId: int.parse(status),
          statusName: statusName,
          statusColor: res['color'], // Assuming API returns color
        );
        // Show snackbar after closing
        CustomSnackbar.show(
          title: "Success",
          message: res['message'] ?? "Status updated successfully",
        );
      } else {
        CustomSnackbar.show(
          title: "Error",
          message: res['message'] ?? "Failed to update status",
        );
      }
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
