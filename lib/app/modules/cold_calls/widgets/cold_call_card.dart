import 'package:benevolent_crm_app/app/modules/cold_calls/controllers/cold_call_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/cold_call_model.dart';

class ColdCallCard extends StatelessWidget {
  final ColdCall call;
  const ColdCallCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<ColdCallController>();
    final busy = ctrl.workingIds.contains(call.id);
    final filters = Get.isRegistered<FiltersController>()
        ? Get.find<FiltersController>()
        : Get.put(FiltersController(), permanent: true);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                call.name.isNotEmpty ? call.name : 'Unnamed',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              _statusPill(call.status),
            ],
          ),
          const SizedBox(height: 8),
          // Meta rows
          _metaRow(
            Icons.badge_outlined,
            'Agent',
            call.agent.isNotEmpty ? call.agent : 'Unassigned',
          ),
          _metaRow(Icons.campaign_outlined, 'Source', call.source),
          _metaRow(Icons.calendar_today_outlined, 'Date', call.date),

          const SizedBox(height: 12),

          // Actions
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                icon: FontAwesomeIcons.whatsapp,
                label: 'WhatsApp',
                fg: const Color(0xFF1FA855),
                bg: const Color(0xFFE8F5E9),
                onTap: () => _whatsapp(call.phone, 'Hi ${call.name}, '),
              ),
              _chip(
                icon: Icons.call,
                label: 'Call',
                fg: const Color(0xFF1565C0),
                bg: const Color(0xFFE3F2FD),
                onTap: () => _call(call.phone),
              ),
              _chip(
                icon: Icons.copy_rounded,
                label: 'Copy',
                fg: const Color(0xFF374151),
                bg: const Color(0xFFF3F4F6),
                onTap: () => _copy(
                  'Name: ${call.name}\nPhone: ${call.phone}\nSource: ${call.source}',
                ),
              ),

              _chip(
                icon: Icons.swap_horiz,
                label: busy ? 'Updating…' : 'Change Status',
                fg: const Color(0xFF6D28D9),
                bg: const Color(0xFFEDE9FE),
                onTap: busy ? () {} : () => _pickStatus(context, ctrl),
              ),
              _chip(
                icon: Icons.person_add_alt_1,
                label: busy ? 'Converting…' : 'Convert',
                fg: const Color(0xFF0F766E),
                bg: const Color(0xFFCCFBF1),
                onTap: busy ? () {} : () => _confirmConvert(context, ctrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    final map = {
      'New': [Colors.orange.shade50, Colors.deepOrange],
      'Hot': [Colors.red.shade50, Colors.red],
      'Warm': [Colors.yellow.shade50, Colors.orange],
      'Cold': [Colors.blue.shade50, Colors.blue],
      'Converted': [Colors.green.shade50, Colors.green.shade800],
    };
    final colors = map[status] ?? [Colors.grey.shade100, Colors.grey.shade700];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[0],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[1], width: 0.6),
      ),
      child: Text(
        status.isEmpty ? 'Unknown' : status,
        style: TextStyle(
          color: colors[1],
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color fg,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----- actions -----
  Future<void> _whatsapp(String raw, String pre) async {
    final phone = _normalizePhone(raw);
    final text = Uri.encodeComponent(pre);
    final uri = Uri.parse('https://wa.me/$phone?text=$text');
    await _launch(uri);
  }

  Future<void> _call(String raw) async {
    final phone = _normalizePhone(raw, keepPlus: true);
    final uri = Uri(scheme: 'tel', path: phone);
    await _launch(uri);
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Cold call info copied',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Action failed',
        'Could not open: $uri',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  String _normalizePhone(String input, {bool keepPlus = false}) {
    final digits = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.startsWith('+')) return keepPlus ? digits : digits.substring(1);
    if (digits.length == 10) {
      return keepPlus ? '+91$digits' : '91$digits';
    }
    return keepPlus ? '+$digits' : digits;
  }

  void _pickStatus(BuildContext context, ColdCallController ctrl) {
    final filters = Get.isRegistered<FiltersController>()
        ? Get.find<FiltersController>()
        : Get.put(FiltersController(), permanent: true);

    if (filters.statusList.isEmpty && !filters.isLoading.value) {
      filters.fetchStatus();
    }

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.25,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return _SheetFrame(
            title: 'Change Status',
            child: Obx(() {
              if (filters.isLoading.value && filters.statusList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final list = filters.statusList;
              if (list.isEmpty) {
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Center(child: Text('No statuses available')),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: filters.fetchStatus,
                      child: const Text('Retry'),
                    ),
                  ],
                );
              }

              return ListView.separated(
                controller: scrollController,
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = list[i];
                  return ListTile(
                    title: Text(s.name),
                    trailing: _statusDot(s.color),
                    onTap: () async {
                      Get.back();
                      await ctrl.changeColdCallStatus(
                        callId: call.id,
                        statusId: s.id,
                      );
                    },
                  );
                },
              );
            }),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  void _confirmConvert(BuildContext context, ColdCallController ctrl) {
    final filters = Get.isRegistered<FiltersController>()
        ? Get.find<FiltersController>()
        : Get.put(FiltersController(), permanent: true);

    // Preload if needed
    if (filters.statusList.isEmpty && !filters.isLoading.value) {
      filters.fetchStatus();
    }

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.25,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return _SheetFrame(
            title: 'Convert to Lead',
            child: Obx(() {
              final list = filters.statusList;

              // Build a single scrolling list:
              // index 0 = "Convert (no status)"
              // 1..N   = each status
              final itemCount = 1 + list.length;

              if (filters.isLoading.value && list.isEmpty) {
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: const [Center(child: CircularProgressIndicator())],
                );
              }

              return ListView.separated(
                controller: scrollController,
                itemCount: itemCount,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return ListTile(
                      leading: const Icon(Icons.check),
                      title: const Text('Convert (no status)'),
                      onTap: () async {
                        Get.back();
                        await ctrl.convertColdCallToLead(callId: call.id);
                      },
                    );
                  }
                  final s = list[i - 1];
                  return ListTile(
                    title: Text('Convert with: ${s.name}'),
                    trailing: _statusDot(s.color),
                    onTap: () async {
                      Get.back();
                      await ctrl.convertColdCallToLead(
                        callId: call.id,
                        statusId: s.id,
                      );
                    },
                  );
                },
              );
            }),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}

/// ===== Helpers for a nice draggable sheet frame =====

class _SheetFrame extends StatelessWidget {
  final String title;
  final Widget child;
  const _SheetFrame({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              _Grabber(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: Get.back,
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

Widget _statusDot(String? hex) {
  if (hex == null || hex.isEmpty) return const SizedBox.shrink();
  Color? c;
  var s = hex.replaceAll('#', '');
  if (s.length == 6) s = 'FF$s';
  final v = int.tryParse(s, radix: 16);
  if (v != null) c = Color(v);
  return c == null
      ? const SizedBox.shrink()
      : Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );
}
