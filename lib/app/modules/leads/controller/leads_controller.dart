import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';

class LeadsController extends GetxController {
  final LeadsService _leadService = LeadsService();

  var leads = <Lead>[].obs;
  var selectedLead = Rxn<Lead>();
  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;

  // 👇 Add filter fields
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
    fetchLeads(reset: true);
  }

  Future<void> applyFilters(LeadRequestModel newFilters) async {
    filters.value = newFilters;
    print("new filter");
    print(filters.value.campaign);

    await fetchLeads(reset: true);
  }

  Future<void> fetchLeads({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      leads.clear();
    }

    if (reset) {
      isLoading.value = true;
    } else {
      isPaginating.value = true;
    }

    try {
      final result = await _leadService.fetchLeads(
        requestModel: filters.value,
        page: currentPage.value,
      );

      lastPage.value = result.data.lastPage;
      leads.addAll(result.data.leads);
      currentPage.value++;
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool get canLoadMore => currentPage.value <= lastPage.value;
}
