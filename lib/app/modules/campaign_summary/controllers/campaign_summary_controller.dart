import 'package:benevolent_crm_app/app/modules/campaign_summary/models/campaign_summary_model.dart';
import 'package:benevolent_crm_app/app/services/campaign_summary_service.dart';
import 'package:get/get.dart';

class CampaignSummaryController extends GetxController {
  final CampaignSummaryService _service = CampaignSummaryService();
  var isLoading = false.obs;
  var campaignSummaryData = <CampaignSummaryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCampaignSummaryReport();
  }

  Future<void> getCampaignSummaryReport() async {
    try {
      isLoading(true);
      final response = await _service.getCampaignSummaryReport();
      if (response.data != null) {
        campaignSummaryData.assignAll(response.data!);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
