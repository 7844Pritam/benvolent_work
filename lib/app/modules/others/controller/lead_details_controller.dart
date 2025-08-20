// lead_details_controller.dart
import 'package:benevolent_crm_app/app/modules/leads/modals/lead_details_response.dart';
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
      : "No status assigned";

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
    if (phone.trim().isEmpty) {
      CustomSnackbar.show(
        title: 'Validation',
        message: 'Phone cannot be empty',
        type: ToastType.info,
      );
      return;
    }

    isSavingPhone.value = true;
    try {
      final res = await _service.updateAdditionalPhone(
        leadId: leadId,
        additionalPhone: phone.trim(),
      );

      CustomSnackbar.show(
        title: 'Success',
        message: (res.message.isNotEmpty)
            ? res.message
            : 'Additional phone updated successfully',
        type: ToastType.success,
      );

      // ✅ Refresh from the canonical getLead which returns List<LeadAssignment>
      await refreshLead();
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isSavingPhone.value = false;
    }
  }
}
