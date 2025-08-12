import 'dart:convert';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/services/leads_service.dart';
import 'package:get/get.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

class LeadsController extends GetxController {
  final LeadsService _leadService = LeadsService();

  var leads = <Lead>[].obs;
  var selectedLead = Rxn<Lead>();
  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var noResults = false.obs; // true when latest (reset) fetch returned 0

  final Rx<LeadRequestModel> currentFilters = LeadRequestModel(
    agentId: '',
    fromDate: '',
    toDate: '',
    status: '',
    campaign: '',
    keyword: '',
    developerId: '',
    propertyId: '',
    priority: '',
  ).obs;

  var filters = LeadRequestModel(
    agentId: "",
    fromDate: "",
    toDate: "",
    developerId: "",
    propertyId: "",
    status: "",
    campaign: "",
    priority: "",
    keyword: "",
  ).obs;
  LeadRequestModel _copy(
    LeadRequestModel s, {
    String? agentId,
    String? fromDate,
    String? toDate,
    String? status,
    String? campaign,
    String? keyword,
    String? developerId,
    String? propertyId,
    String? priority,
  }) {
    return LeadRequestModel(
      agentId: agentId ?? s.agentId,
      fromDate: fromDate ?? s.fromDate,
      toDate: toDate ?? s.toDate,
      status: status ?? s.status,
      campaign: campaign ?? s.campaign,
      keyword: keyword ?? s.keyword,
      developerId: developerId ?? s.developerId,
      propertyId: propertyId ?? s.propertyId,
      priority: priority ?? s.priority,
    );
  }

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
      final dt = _parseDateFlexible(lead.date) ?? _parseDateFlexible(lead.date);
      // Fallback: if still null, group under "Unknown"
      final key = dt != null ? _outFmt.format(dt) : 'Unknown';
      (out[key] ??= []).add(lead);
    }

    // Sort each day's leads optionally by time descending if available
    out.forEach((key, list) {
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

  /// Sorted date keys with newest first (Unknown goes last).
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

  // Future<void> applyFilters(LeadRequestModel newFilters) async {
  //   filters.value = newFilters;
  //   print("Applying filters: ${filters.value.toJson()}");
  //   await fetchLeads(reset: true);
  // }
  Future<void> applyFilters(LeadRequestModel newFilters) async {
    currentFilters.value = newFilters;
    currentFilters.refresh();
    print("Applying66666 fisdfsdlters: ${currentFilters.value.toJson()}");
    try {
      print("Applying filters5555: ${currentFilters.value.toJson()}");
      await fetchLeads(reset: true);
    } catch (e) {
      print('Error applying88888 filters: $e');
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    }
    print("1111Appliedsfdfs filters: ${currentFilters.value.toJson()}");
    if (noResults.value) {
      CustomSnackbar.show(
        title: 'No results',
        message: 'No leads match your filters.',
        type: ToastType.info,
      );
    }
  }

  Future<void> removeFilter(String key) async {
    final f = currentFilters.value;
    switch (key) {
      case 'agent':
        currentFilters.value = _copy(f, agentId: '');
        break;
      case 'status':
        currentFilters.value = _copy(f, status: '');
        break;
      case 'campaign':
        currentFilters.value = _copy(f, campaign: '');
        break;
      case 'keyword':
        currentFilters.value = _copy(f, keyword: '');
        break;
      case 'daterange':
        currentFilters.value = _copy(f, fromDate: '', toDate: '');
        break;
      case 'priority':
        currentFilters.value = _copy(f, priority: '');
        break;
      case 'developer':
        currentFilters.value = _copy(f, developerId: '');
        break;
      case 'property':
        currentFilters.value = _copy(f, propertyId: '');
        break;
    }
    currentFilters.refresh();
    await fetchLeads(reset: true);
  }

  // Clear everything and refresh
  Future<void> clearAllFilters() async {
    currentFilters.value = LeadRequestModel(
      agentId: '',
      fromDate: '',
      toDate: '',
      status: '',
      campaign: '',
      keyword: '',
      developerId: '',
      propertyId: '',
      priority: '',
    );
    currentFilters.refresh();
    await fetchLeads(reset: true);
  }

  Future<void> fetchLeads({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      leads.clear();
      noResults.value = false; // reset state before loading
    }

    if (reset) {
      isLoading.value = true;
    } else {
      isPaginating.value = true;
    }

    try {
      final result = await _leadService.fetchLeads(
        requestModel:
            currentFilters.value, // make sure you're using currentFilters
        page: currentPage.value,
      );

      lastPage.value = result.data.lastPage;

      // add page results
      final newItems = result.data.data.map((e) => e).toList();
      leads.addAll(newItems);

      // if this was a reset fetch and total is 0 => mark noResults
      if (reset && leads.isEmpty) {
        noResults.value = true;
      } else if (reset) {
        noResults.value = false;
      }

      currentPage.value++;
    } catch (e, stackTrace) {
      // your existing error handling
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

  bool get canLoadMore => currentPage.value <= lastPage.value;
}
