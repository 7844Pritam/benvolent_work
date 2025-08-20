import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/services/coldcalls_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ColdCallController extends GetxController {
  final ColdCallService _service = ColdCallService();

  final coldCalls = <ColdCall>[].obs;
  final isLoading = false.obs;
  final isPaginating = false.obs;
  var currentPage = 1;
  var lastPage = 1;
  final totalCount = 0.obs;

  final workingIds = <int>{}.obs;
  final currentFilters = LeadRequestModel(
    agentId: "",
    fromDate: "",
    toDate: "",
    developerId: "",
    propertyId: "",
    status: "",
    campaign: "",
    priority: "",
    keyword: "",
    source: "",
    isFresh: "",
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
    final fmts = <DateFormat>[
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM/dd/yyyy'),
    ];
    for (final f in fmts) {
      try {
        return f.parseStrict(raw);
      } catch (_) {}
    }
    return null;
  }

  /// Map grouped by 'dd/MM/yyyy'
  Map<String, List<ColdCall>> get groupedCalls {
    final Map<String, List<ColdCall>> out = {};
    for (final c in coldCalls) {
      final dt = _parseDateFlexible(c.date);
      final key = dt != null ? _outFmt.format(dt) : 'Unknown';
      (out[key] ??= []).add(c);
    }
    // sort items inside each day (newest first)
    out.forEach((_, v) {
      v.sort((a, b) {
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

  /// Sorted date keys (newest first, "Unknown" last)
  List<String> get groupedDateKeys {
    final keys = groupedCalls.keys.toList();
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
    fetchColdCalls(reset: true);
  }

  /// Called by FilterPage when user taps "Apply"
  void applyFilters(LeadRequestModel newFilters) {
    currentFilters.value = newFilters;
    fetchColdCalls(reset: true);
  }

  /// Called by chips bar "Clear" button
  Future<void> clearFilters() async {
    currentFilters.value = currentFilters.value.copyWith(
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
    fetchColdCalls(reset: true);
  }

  /// Remove a single chip/tag (CSV ones remove a single id)
  Future<void> removeTag(String key, {int? id}) async {
    String _removeFromCsv(String csv, int id) {
      final set = csv.split(',').where((e) => e.trim().isNotEmpty).toSet();
      set.remove(id.toString());
      return set.join(',');
    }

    final f = currentFilters.value;
    switch (key) {
      case 'agent_id':
        applyFilters(f.copyWith(agentId: ''));
        break;
      case 'date_range':
        applyFilters(f.copyWith(fromDate: '', toDate: ''));
        break;
      case 'status':
        applyFilters(
          f.copyWith(status: id == null ? '' : _removeFromCsv(f.status, id)),
        );
        break;
      case 'campaign':
        applyFilters(
          f.copyWith(
            campaign: id == null ? '' : _removeFromCsv(f.campaign, id),
          ),
        );
        break;
      case 'source':
        applyFilters(
          f.copyWith(source: id == null ? '' : _removeFromCsv(f.source, id)),
        );
        break;
      case 'is_fresh':
        applyFilters(f.copyWith(isFresh: ''));
        break;
      case 'keyword':
        applyFilters(f.copyWith(keyword: ''));
        break;
    }
  }

  void fetchColdCalls({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      coldCalls.clear();
      isLoading.value = true;
    } else {
      if (isPaginating.value || !canLoadMore) return;
      isPaginating.value = true;
      currentPage++;
    }

    try {
      final response = await _service.fetchColdCalls(
        currentPage,
        requestModel: currentFilters.value, // ✅ use active chips filters
      );
      coldCalls.addAll(response.data);
      lastPage = response.lastPage;
      totalCount.value = response.count; // Update total count
    } catch (e) {
      // optional: show a toast
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool get canLoadMore => currentPage <= lastPage;

  // ------------ Actions ------------
  Future<void> changeColdCallStatus({
    required int callId,
    required int statusId,
    bool refreshAfter = true,
  }) async {
    if (workingIds.contains(callId)) return;
    workingIds.add(callId);
    try {
      final res = await _service.changeColdCallStatus(
        callId: callId,
        status: statusId,
      );
      CustomSnackbar.show(
        title: 'Success',
        message: res.message.isNotEmpty ? res.message : 'Status updated',
        type: ToastType.success,
      );
      if (refreshAfter) {
        fetchColdCalls(reset: true);
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Failed',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      workingIds.remove(callId);
    }
  }

  Future<void> convertColdCallToLead({
    required int callId,
    int? statusId,
    bool refreshAfter = true,
  }) async {
    if (workingIds.contains(callId)) return;
    workingIds.add(callId);
    try {
      final res = await _service.convertColdCall(
        callId: callId,
        status: statusId,
      );
      CustomSnackbar.show(
        title: res.success == 200 ? 'Converted' : 'Failed',
        message: res.message,
        type: res.success == 200 ? ToastType.success : ToastType.error,
      );
      if (res.success == 200) {
        if (refreshAfter) {
          fetchColdCalls(reset: true);
        } else {
          coldCalls.removeWhere((c) => c.id == callId);
        }
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Failed',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      workingIds.remove(callId);
    }
  }
}
