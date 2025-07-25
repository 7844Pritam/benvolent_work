import 'package:benevolent_crm_app/app/services/filters/status_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';

class StatusController extends GetxController {
  final StatusService _statusService = StatusService();

  var isLoading = false.obs;
  var statusList = <LeadStatus>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _statusService.getStatuses();
      statusList.assignAll(response.data ?? []);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
