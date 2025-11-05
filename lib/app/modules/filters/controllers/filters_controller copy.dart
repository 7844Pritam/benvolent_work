// import 'package:benevolent_crm_app/app/modules/filters/modals/agents_response.dart';
// import 'package:benevolent_crm_app/app/modules/filters/modals/campaigns_response.dart';
// import 'package:benevolent_crm_app/app/modules/filters/modals/lead_status_response.dart';
// import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';
// import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';
// import 'package:benevolent_crm_app/app/modules/filters/modals/sub_status_response.dart';
// import 'package:benevolent_crm_app/app/services/filter_services.dart';
// import 'package:get/get.dart';

// class FiltersController extends GetxController {
//   final FiltersServices _filterService = FiltersServices();

//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   // var agentsLists = <AgentsResponse>[].obs;
//   var agentsList = <Agent>[].obs;

//   var campaignList = <Campaign>[].obs;
//   var sourceList = <SourceData>[].obs;
//   var statusList = <LeadStatus>[].obs;
//   var subStatusList = <SubStatus>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAgents();
//     fetchStatus();
//     fetchCampaigns();
//     // fetchSources(campaignId: '2');
//     fetchSubStatus();
//   }

//   Future<void> fetchAgents() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       print('Agents fetched new ');
//       final response = await _filterService.getAgents();
//       print('Agents fetched: ${response.data}');
//       agentsList.assignAll(response.data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print('Error fetching agents: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   List<SubStatus> subStatusesFor(String statusId) {
//     if (statusId.isEmpty) return const [];
//     return subStatusList
//         .where((s) => (s.statusId.toString()) == statusId)
//         .toList();
//   }

//   Future<void> fetchStatus() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final response = await _filterService.getStatuses(
//         SourceRequest(compaignId: "campaignId"),
//       );
//       statusList.assignAll(response.data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchSources({required String campaignId}) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final response = await _filterService.getSources(
//         SourceRequest(compaignId: "2"),
//       );
//       sourceList.assignAll(response.data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//       sourceList.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchCampaigns() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final response = await _filterService.getCampaigns();
//       campaignList.assignAll(response.data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchSubStatus() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final response = await _filterService.getSubStatus();
//       subStatusList.assignAll(response.data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
