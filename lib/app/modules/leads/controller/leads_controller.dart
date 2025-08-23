import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';

import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeadsController extends GetxController {
  final LeadsService _leadService = LeadsService();
  // final FiltersController _filters = Get.find<FiltersController>();

  final leads = <Lead>[].obs;
  final selectedLead = Rxn<Lead>();
  final isLoading = false.obs;
  final isPaginating = false.obs;
  final noResults = false.obs;
  final totalCount = 0.obs;

  int currentPage = 1;
  int lastPage = 1;

  final currentFilters = LeadRequestModel(
    agentId: '',
    fromDate: '',
    toDate: '',
    status: '',
    campaign: '',
    keyword: '',
    developerId: '',
    propertyId: '',
    priority: '',
    source: '',
    isFresh: '',
  ).obs;

  // ---------- Date helpers ----------
  final DateFormat _outFmt = DateFormat('dd/MM/yyyy');

  DateTime? _parseDateFlexible(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final isoCandidate = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
      final dt = DateTime.tryParse(isoCandidate);
      if (dt != null) return dt;
    } catch (_) {}

    final candidates = <DateFormat>[
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM/dd/yyyy'),
    ];

    for (final f in candidates) {
      try {
        return f.parseStrict(raw);
      } catch (_) {}
    }
    return null;
  }

  Map<String, List<Lead>> get groupedLeads {
    final Map<String, List<Lead>> out = {};
    for (final lead in leads) {
      final dt = _parseDateFlexible(lead.date);
      final key = dt != null ? _outFmt.format(dt) : 'Unknown';
      (out[key] ??= []).add(lead);
    }

    // Sort each day's leads by date desc
    out.forEach((_, list) {
      list.sort((a, b) {
        final da =
            _parseDateFlexible(a.date) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final db =
            _parseDateFlexible(b.date) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return db.compareTo(da);
      });
    });

    return out;
  }

  List<String> get groupedDateKeys {
    final keys = groupedLeads.keys.toList();
    keys.sort((a, b) {
      if (a == 'Unknown') return 1;
      if (b == 'Unknown') return -1;
      final da = _outFmt.parse(a);
      final db = _outFmt.parse(b);
      return db.compareTo(da);
    });
    return keys;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeads(reset: true);
  }

  // ---------- Filters ----------
  Future<void> applyFilters(LeadRequestModel newFilters) async {
    currentFilters.value = newFilters;
    currentFilters.refresh();
    try {
      await fetchLeads(reset: true);
      if (noResults.value) {
        CustomSnackbar.show(
          title: 'No results',
          message: 'No leads match your filters.',
          type: ToastType.info,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    }
  }

  Future<void> removeTag(String key, {int? id}) async {
    String _removeFromCsv(String csv, int id) {
      final set = csv.split(',').where((e) => e.trim().isNotEmpty).toSet();
      set.remove(id.toString());
      return set.join(',');
    }

    final f = currentFilters.value;
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
      case 'developer':
        await applyFilters(f.copyWith(developerId: ''));
        break;
      case 'property':
        await applyFilters(f.copyWith(propertyId: ''));
        break;
      case 'priority':
        await applyFilters(f.copyWith(priority: ''));
        break;
    }
  }

  Future<void> clearAllFilters() async {
    await applyFilters(
      LeadRequestModel(
        agentId: '',
        fromDate: '',
        toDate: '',
        status: '',
        campaign: '',
        keyword: '',
        developerId: '',
        propertyId: '',
        priority: '',
        source: '',
        isFresh: '',
      ),
    );
  }

  Future<void> fetchLeads({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      lastPage = 1;
      leads.clear();
      noResults.value = false;
      isLoading.value = true;
    } else {
      if (isPaginating.value || !canLoadMore) return;
      isPaginating.value = true;
    }

    try {
      final result = await _leadService.fetchLeads(
        requestModel: currentFilters.value,
        page: currentPage,
      );

      lastPage = result.data.lastPage;
      final newItems = result.data.data.toList();
      leads.addAll(newItems);
      totalCount.value = result.data.total;
      if (reset && leads.isEmpty) {
        noResults.value = true;
      }

      if (currentPage < lastPage) {
        currentPage++;
      } else {
        currentPage = lastPage + 1;
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool get canLoadMore => currentPage <= lastPage;

  void updateLeadStatus({
    required int leadId,
    required int statusId,
    required String statusName,
    int?
    subStatusId, // Ignored for now, as Lead model doesn't support sub-status
  }) {
    final leadIndex = leads.indexWhere((lead) => lead.id == leadId);
    if (leadIndex != -1) {
      final updatedLead = leads[leadIndex].copyWith(
        status: statusId,
        statusName: statusName,
      );

      // Check if the updated lead matches active filters
      final filters = currentFilters.value;
      final statusFilter = filters.status
          .split(',')
          .where((e) => e.isNotEmpty)
          .toList();
      if (statusFilter.isEmpty || statusFilter.contains(statusId.toString())) {
        leads[leadIndex] = updatedLead;
      } else {
        leads.removeAt(leadIndex);
        totalCount.value--;
      }
    }
  }
}
