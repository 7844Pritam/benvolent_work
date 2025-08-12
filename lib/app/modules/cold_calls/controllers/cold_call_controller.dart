import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/services/coldcalls_service.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ColdCallController extends GetxController {
  final ColdCallService _service = ColdCallService();

  var coldCalls = <ColdCall>[].obs;
  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1;
  var lastPage = 1;
  final workingIds = <int>{}.obs;
  // 🔍 Filter model
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
    out.forEach((k, v) {
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

  void applyFilters(LeadRequestModel newFilters) {
    filters.value = newFilters;
    fetchColdCalls(reset: true);
  }

  void fetchColdCalls({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      coldCalls.clear();
    }

    if (reset) {
      isLoading.value = true;
    } else {
      isPaginating.value = true;
    }

    try {
      final response = await _service.fetchColdCalls(
        currentPage,
        requestModel: filters.value,
      );
      coldCalls.addAll(response.data);
      lastPage = response.lastPage;
      currentPage++;
    } catch (e) {
      // handle/log as needed
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool get canLoadMore => currentPage <= lastPage;

  // cold_call_controller.dart (only methods shown)

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
