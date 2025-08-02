import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/services/coldcalls_service.dart';
import 'package:get/get.dart';

class ColdCallController extends GetxController {
  final ColdCallService _service = ColdCallService();

  var coldCalls = <ColdCall>[].obs;
  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1;
  var lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchColdCalls(reset: true);
  }

  void fetchColdCalls({bool reset = false}) async {
    print("response from cold call controller12");

    if (reset) {
      currentPage = 1;
      coldCalls.clear();
    }

    if (reset) {
      isLoading.value = true;
    } else {
      isPaginating.value = true;
    }
    print("response from cold call controller11");

    try {
      final response = await _service.fetchColdCalls(currentPage);
      print("response from cold call controller");
      print(response);
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
