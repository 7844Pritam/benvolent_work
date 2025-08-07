import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart'; // reuse
import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/services/change_status_service.dart';
import 'package:benevolent_crm_app/app/services/converted_call_service.dart';
import 'package:get/get.dart';

class ConvertedCallController extends GetxController {
  final ConvertedCallService _service = ConvertedCallService();
  final ChangeStatusService _service2 = ChangeStatusService();

  RxList<ConvertedCall> calls = <ConvertedCall>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPaginating = false.obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  // 🆕 Add filters
  var filters = LeadRequestModel(
    agentId: '',
    fromDate: '',
    toDate: '',
    developerId: '',
    propertyId: '',
    status: '',
    campaign: '',
    priority: '',
    keyword: '',
  ).obs;

  bool get canLoadMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    fetchCalls(initial: true);
    super.onInit();
  }

  Future<void> applyFilters(LeadRequestModel newFilters) async {
    filters.value = newFilters;
    await fetchCalls(initial: true);
  }

  Future<void> fetchCalls({bool initial = false}) async {
    if (initial) {
      isLoading.value = true;
      currentPage.value = 1;
    } else {
      isPaginating.value = true;
      currentPage.value += 1;
    }

    try {
      final response = await _service.fetchConvertedCalls(
        requestModel: filters.value,
        page: currentPage.value,
      );
      if (initial) {
        calls.value = response.data;
      } else {
        calls.addAll(response.data);
      }
      lastPage.value = response.lastPage;
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  void changeStatus(
    int id,
    String status,
    String subStatus,
    String comment,
  ) async {
    try {
      final res = await _service2.changeStatus(
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
