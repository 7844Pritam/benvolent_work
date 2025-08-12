import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/sub_status_response.dart';

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
  var subStatusList = <SubStatus>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
    fetchCampaigns();
    fetchSources(campaignId: '');
    fetchSubStatus();
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
    print('Fetching sources for campaign ID: $campaignId');

    try {
      final response = await _filterService.getSources(
        SourceRequest(compaignId: campaignId),
      );
      print('Sources fetched successfully: ${response.data}');
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

  Future<void> fetchSubStatus() async {
    print('Fetching sub-statuses...');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _filterService.getSubStatus();
      print('Sub-statuses fetched successfully: ${response.data.toList()}');
      subStatusList.assignAll(response.data);
      print('Sub-statuses fetched successfully: ${subStatusList}');
    } catch (e) {
      print('Error fetching sub-statuses: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
