import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/services/coldcalls_service.dart';
import 'package:get/get.dart';

class ColdCallController extends GetxController {
  final ColdCallService _service = ColdCallService();

  var coldCalls = <ColdCall>[].obs;
  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1;
  var lastPage = 1;

  // 🔍 Filter model
  var filters = LeadRequestModel(
    agentId: "",
    fromDate: "",
    toDate: "",
    developerId: "",
    propertyId: "",
    status: "",
    campaign: "",
    priority: "",
    keyword: "",
  ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchColdCalls(reset: true);
  }

  void applyFilters(LeadRequestModel newFilters) {
    filters.value = newFilters;
    fetchColdCalls(reset: true);
  }

  void fetchColdCalls({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      coldCalls.clear();
    }

    if (reset) {
      isLoading.value = true;
    } else {
      isPaginating.value = true;
    }

    try {
      final response = await _service.fetchColdCalls(
        currentPage,
        requestModel: filters.value,
      );
      coldCalls.addAll(response.data);
      lastPage = response.lastPage;
      currentPage++;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool get canLoadMore => currentPage <= lastPage;
}
