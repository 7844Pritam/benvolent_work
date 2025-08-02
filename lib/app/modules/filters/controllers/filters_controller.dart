import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';

import 'package:benevolent_crm_app/app/services/filter_services.dart';
import 'package:get/get.dart';

class FiltersController extends GetxController {
  final FiltersServices _filterService = FiltersServices();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // var agentList = Map<String,>[].obs;
  var campaignList = <Campaign>[].obs;
  var sourceList = <SourceData>[].obs;
  var statusList = <LeadStatus>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
    fetchCampaigns();
    fetchSources(campaignId: '');
  }

  Future<void> fetchStatus() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _filterService.getStatuses(
        SourceRequest(compaignId: "campaignId"),
      );
      print(response.message);
      print(response.data.map((data) => print(data.name)));
      statusList.assignAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSources({required String campaignId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _filterService.getSources(
        SourceRequest(compaignId: campaignId),
      );

      sourceList.assignAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
      sourceList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCampaigns() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _filterService.getCampaigns();
      campaignList.assignAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
