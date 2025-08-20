// lib/app/modules/converted_call/controller/converted_call_controller.dart
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/services/converted_call_service.dart';
import 'package:get/get.dart';

class ConvertedCallController extends GetxController {
  final ConvertedCallService _service = ConvertedCallService();
  final calls = <ConvertedCall>[].obs;
  final isLoading = false.obs;
  final isPaginating = false.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalCount = 0.obs;

  // active filters
  final currentFilters = LeadRequestModel(
    agentId: '',
    fromDate: '',
    toDate: '',
    developerId: '',
    propertyId: '',
    status: '',
    campaign: '',
    priority: '',
    keyword: '',
    source: '',
    isFresh: '',
  ).obs;

  bool get canLoadMore => currentPage.value < lastPage.value;

  @override
  void onInit() {
    fetchCalls(initial: true);
    super.onInit();
  }

  Future<void> applyFilters(LeadRequestModel newFilters) async {
    currentFilters.value = newFilters;
    await fetchCalls(initial: true);
  }

  Future<void> clearFilters() async {
    currentFilters.value = LeadRequestModel(
      agentId: '',
      fromDate: '',
      toDate: '',
      developerId: '',
      propertyId: '',
      status: '',
      campaign: '',
      priority: '',
      keyword: '',
      source: '',
      isFresh: '',
    );
    await fetchCalls(initial: true);
  }

  Future<void> fetchCalls({bool initial = false}) async {
    if (initial) {
      isLoading.value = true;
      currentPage.value = 1;
      calls.clear();
    } else {
      if (isPaginating.value || !canLoadMore) return;
      isPaginating.value = true;
      currentPage.value += 1;
    }

    try {
      final res = await _service.fetchConvertedCalls(
        page: currentPage.value,
        requestModel: currentFilters.value,
      );
      totalCount.value = res.total;

      calls.addAll(res.data);
      lastPage.value = res.lastPage;
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  /// Remove a single tag by key. For CSV filters, pass the id to remove.
  Future<void> removeTag(String key, {int? id}) async {
    final f = currentFilters.value;

    String _removeFromCsv(String csv, int id) {
      final set = csv.split(',').where((e) => e.trim().isNotEmpty).toSet();
      set.remove(id.toString());
      return set.join(',');
    }

    switch (key) {
      case 'agent_id':
        await applyFilters(f.copyWith(agentId: ''));
        break;
      case 'date_range':
        await applyFilters(f.copyWith(fromDate: '', toDate: ''));
        break;
      case 'status':
        await applyFilters(
          f.copyWith(status: id == null ? '' : _removeFromCsv(f.status, id)),
        );
        break;
      case 'campaign':
        await applyFilters(
          f.copyWith(
            campaign: id == null ? '' : _removeFromCsv(f.campaign, id),
          ),
        );
        break;
      case 'source':
        await applyFilters(
          f.copyWith(source: id == null ? '' : _removeFromCsv(f.source, id)),
        );
        break;
      case 'is_fresh':
        await applyFilters(f.copyWith(isFresh: ''));
        break;
      case 'keyword':
        await applyFilters(f.copyWith(keyword: ''));
        break;
    }
  }
}

// add a copyWith to LeadRequestModel
