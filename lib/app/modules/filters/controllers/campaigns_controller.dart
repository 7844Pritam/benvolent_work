import 'package:benevolent_crm_app/app/services/filters/campaigns_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';

class CampaignsController extends GetxController {
  final CampaignsService _campaignsService = CampaignsService();

  var isLoading = false.obs;
  var campaignList = <Campaign>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _campaignsService.getCampaigns();
      campaignList.assignAll(response.data ?? []);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
