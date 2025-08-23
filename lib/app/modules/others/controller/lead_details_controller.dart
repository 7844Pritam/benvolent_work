import 'package:benevolent_crm_app/app/modules/others/modals/lead_details_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  final LeadsService _service;
  final isSavingPhone = false.obs;

  LeadDetailsController({LeadsService? service})
    : _service = service ?? LeadsService();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final lead = Rxn<LeadAssignment>();
  final leadId = 0.obs;

  Future<void> load(int id) async {
    leadId.value = id;
    isLoading.value = true;
    errorMessage.value = null;
    lead.value = null;

    try {
      final res = await _service.fetchLeadById(id);
      if (res.data.isEmpty) {
        errorMessage.value = 'Lead not found';
      } else {
        lead.value = res.data.first;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLead() => load(leadId.value);

  Lead? get model => lead.value?.lead;

  String get leadName => model?.name?.trim().isNotEmpty == true
      ? model!.name!
      : "Lead name not available";

  String get statusName => model?.statuses?.name?.trim().isNotEmpty == true
      ? model!.statuses!.name!
      : "None";

  String get sourceName => model?.sources?.name?.trim().isNotEmpty == true
      ? model!.sources!.name!
      : "Source not provided";

  String get campaignName => model?.campaign?.name?.trim().isNotEmpty == true
      ? model!.campaign!.name!
      : "No campaign selected";

  Future<void> updateAdditionalPhone({
    required int leadId,
    required String phone,
  }) async {
    isSavingPhone.value = true;
    try {
      final res = await _service.updateAdditionalPhone(
        leadId: leadId,
        additionalPhone: phone.trim(),
      );

      Get.back();

      CustomSnackbar.show(
        title: 'Success',
        message: (res.message.isNotEmpty)
            ? res.message
            : 'Additional phone updated successfully',
        type: ToastType.success,
      );

      await refreshLead();
    } catch (e) {
      // CustomSnackbar.show(
      //   title: 'Success',
      //   message: 'Additional phone updated successfully',
      //   type: ToastType.success,
      // );
      // Get.back();
      await refreshLead();

      print(e.toString());
      // CustomSnackbar.show(
      //   title: 'Error',
      //   message: e.toString(),
      //   type: ToastType.error,
      // );
    } finally {
      isSavingPhone.value = false;
    }
  }

  void updateLeadStatus({
    required int statusId,
    required String statusName,
    String? statusColor,
    int? subStatusId,
  }) {
    if (lead.value?.lead == null) return;
    final updatedStatuses =
        lead.value!.lead.statuses?.copyWith(
          id: statusId,
          name: statusName,
          color: statusColor ?? lead.value!.lead.statuses?.color,
        ) ??
        StatusInfo(
          id: statusId,
          name: statusName,
          color: statusColor,
          statusOrder: null,
          isDefault: null,
          approveStatus: null,
          superStatusId: null,
          createdAt: null,
          updatedAt: null,
        );
    final updatedLead = lead.value!.lead.copyWith(
      statusId: statusId,
      subStatusId: subStatusId ?? lead.value!.lead.subStatusId,
      statuses: updatedStatuses,
    );
    lead.value = lead.value!.copyWith(lead: updatedLead);
  }
}
