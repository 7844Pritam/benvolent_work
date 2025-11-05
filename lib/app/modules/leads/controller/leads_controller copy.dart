// ─────────────────────────────────────────────────────────────────────────────
//  LeadsController – with updateTag + safe removeTag
// ─────────────────────────────────────────────────────────────────────────────
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeadsController extends GetxController {
  final LeadsService _leadService = LeadsService();

  // ────── Reactive state ──────
  final leads = <Lead>[].obs;
  final selectedLead = Rxn<Lead>();
  final isLoading = false.obs;
  final isPaginating = false.obs;
  final noResults = false.obs;
  final totalCount = 0.obs;

  // ────── Pagination ──────
  int currentPage = 1;
  int lastPage = 1;

  // ────── Current filters (observable) ──────
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

  // ────── Date helpers ──────
  final DateFormat _outFmt = DateFormat('dd/MM/yyyy');

  DateTime? _parseDateFlexible(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    // ISO-8601 with space → T
    try {
      final iso = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
      final dt = DateTime.tryParse(iso);
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

  // ────── Grouped leads (by date) ──────
  Map<String, List<Lead>> get groupedLeads {
    final out = <String, List<Lead>>{};
    for (final lead in leads) {
      final dt = _parseDateFlexible(lead.date);
      final key = dt != null ? _outFmt.format(dt) : 'Unknown';
      (out[key] ??= []).add(lead);
    }

    // Sort each day descending
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

  // ────── Lifecycle ──────
  @override
  void onInit() {
    super.onInit();
    fetchLeads(reset: true);
  }

  // ────── Public API ──────
  /// Apply a brand-new filter set (used by the Filter page)
  Future<void> applyFilters(LeadRequestModel newFilters) async {
    currentFilters.value = newFilters;
    currentFilters.refresh();
    await fetchLeads(reset: true);
    if (noResults.value) {
      CustomSnackbar.show(
        title: 'No results',
        message: 'No leads match your filters.',
        type: ToastType.info,
      );
    }
  }

  /// **NEW** – update a single field **without** resetting the whole filter
  void updateTag(String key, String value) {
    final f = currentFilters.value;
    currentFilters.value = f.copyWith(
      agentId: key == 'agent_id' ? value : f.agentId,
      fromDate: key == 'from_date' ? value : f.fromDate,
      toDate: key == 'to_date' ? value : f.toDate,
      status: key == 'status' ? value : f.status,
      campaign: key == 'campaign' ? value : f.campaign,
      source: key == 'source' ? value : f.source,
      isFresh: key == 'is_fresh' ? value : f.isFresh,
      keyword: key == 'keyword' ? value : f.keyword,
      developerId: key == 'developer' ? value : f.developerId,
      propertyId: key == 'property' ? value : f.propertyId,
      priority: key == 'priority' ? value : f.priority,
    );
    // Immediately refresh the list with the new value
    fetchLeads(reset: true);
  }

  /// Remove a single tag (or clear the whole field when `id` is null)
  Future<void> removeTag(String key, {int? id}) async {
    // Helper – remove a single id from a CSV string
    String _removeFromCsv(String csv, int id) {
      final set = csv
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
      set.remove(id.toString());
      return set.join(',');
    }

    final f = currentFilters.value;
    switch (key) {
      case 'agent_id':
        updateTag('agent_id', '');
        break;
      case 'date_range':
        updateTag('from_date', '');
        updateTag('to_date', '');
        break;
      case 'status':
        final newCsv = id == null ? '' : _removeFromCsv(f.status, id);
        updateTag('status', newCsv);
        break;
      case 'campaign':
        final newCsv = id == null ? '' : _removeFromCsv(f.campaign, id);
        updateTag('campaign', newCsv);
        break;
      case 'source':
        final newCsv = id == null ? '' : _removeFromCsv(f.source, id);
        updateTag('source', newCsv);
        break;
      case 'is_fresh':
        updateTag('is_fresh', '');
        break;
      case 'keyword':
        updateTag('keyword', '');
        break;
      case 'developer':
        updateTag('developer', '');
        break;
      case 'property':
        updateTag('property', '');
        break;
      case 'priority':
        updateTag('priority', '');
        break;
    }
  }

  /// Clear **all** filters at once
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

  // ────── Data fetching ──────
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

      if (reset) {
        leads.assignAll(newItems);
      } else {
        leads.addAll(newItems);
      }

      totalCount.value = result.data.total;
      if (reset && leads.isEmpty) noResults.value = true;

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

  // ────── In-place status update (used by swipe actions) ──────
  void updateLeadStatus({
    required int leadId,
    required int statusId,
    required String statusName,
    int? subStatusId,
  }) {
    final idx = leads.indexWhere((l) => l.id == leadId);
    if (idx == -1) return;

    final updated = leads[idx].copyWith(
      status: statusId,
      statusName: statusName,
    );
    final filters = currentFilters.value;
    final statusCsv = filters.status
        .split(',')
        .where((e) => e.isNotEmpty)
        .toList();

    if (statusCsv.isEmpty || statusCsv.contains(statusId.toString())) {
      leads[idx] = updated;
    } else {
      leads.removeAt(idx);
      totalCount.value--;
    }
  }
}
