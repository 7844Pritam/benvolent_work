import 'package:benevolent_crm_app/app/services/filters/source_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_response.dart';
import 'package:benevolent_crm_app/app/modules/filters/modals/source_request.dart';

class SourceController extends GetxController {
  final SourceService _sourceService = SourceService();

  var isLoading = false.obs;
  var sourceList = <SourceData>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchSources({required String campaignId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _sourceService.getStatuses(
        SourceRequest(compaignId: campaignId),
      );

      final List<SourceData> flattened = [];
      // response.data?.forEach((group, entries) {
      //   if (entries != null && entries.isNotEmpty) {
      //     entries.forEach((id, name) {
      //       flattened.add(SourceData(id: id, name: name));
      //     });
      //   }
      // });

      sourceList.assignAll(flattened);
    } catch (e) {
      errorMessage.value = e.toString();
      sourceList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
