import 'package:benevolent_crm_app/app/modules/campaign_summary/models/campaign_summary_model.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/services/campaign_summary_service.dart';
import 'package:get/get.dart';

class CampaignSummaryController extends GetxController {
  final CampaignSummaryService _service = CampaignSummaryService();
  final FiltersController filtersController = Get.put(FiltersController());

  var isLoading = false.obs;
  var campaignSummaryData = <CampaignSummaryModel>[].obs;

  // Filter State
  var selectedCampaigns = <int>{}.obs;
  var selectedSources = <int>{}.obs;
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  var selectedDateRange = ''.obs;

  get exportSummaryAsCsv => null;

  @override
  void onInit() {
    super.onInit();
    getCampaignSummaryReport();
  }

  Future<void> getCampaignSummaryReport() async {
    try {
      isLoading(true);
      
      String campaignIds = selectedCampaigns.join(',');
      String sourceIds = selectedSources.join(',');
      String? fromDateStr = fromDate.value != null ? fromDate.value!.toIso8601String().split('T')[0] : null;
      String? toDateStr = toDate.value != null ? toDate.value!.toIso8601String().split('T')[0] : null;

      final response = await _service.getCampaignSummaryReport(
        campaignIds: campaignIds,
        sourceIds: sourceIds,
        fromDate: fromDateStr,
        toDate: toDateStr,
      );
      if (response.data != null) {
        campaignSummaryData.assignAll(response.data!);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCampaignSummary() async {
    await getCampaignSummaryReport();
  }
  
  void applyFilters({
    required Set<int> campaigns,
    required Set<int> sources,
    required DateTime? start,
    required DateTime? end,
  }) {
    selectedCampaigns.assignAll(campaigns);
    selectedSources.assignAll(sources);
    fromDate.value = start;
    toDate.value = end;
    
    if (start != null && end != null) {
       // Format as needed
    } else {
       selectedDateRange.value = '';
    }

    getCampaignSummaryReport();
  }

  void clearFilters() {
    selectedCampaigns.clear();
    selectedSources.clear();
    fromDate.value = null;
    toDate.value = null;
    selectedDateRange.value = '';
    getCampaignSummaryReport();
  }
}
