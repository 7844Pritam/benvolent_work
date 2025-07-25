import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/filters/agents_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/agents_response.dart';

class AgentsController extends GetxController {
  final AgentsService _agentsService = AgentsService();

  var isLoading = false.obs;
  var agentList = <Agent>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _agentsService.getAgents();
      // agentList.assignAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
