import 'package:benevolent_crm_app/app/modules/converted_call/constants/call_constants.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:benevolent_crm_app/app/utils/helpers.dart';
import 'package:benevolent_crm_app/app/utils/hyper_links/hyper_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../modals/cold_call_model.dart';
import '../controllers/cold_call_controller.dart';

class ColdCallCard extends StatelessWidget {
  final ColdCall call;
  final bool showConvert;

  const ColdCallCard({super.key, required this.call, this.showConvert = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<ColdCallController>();
    final busy = ctrl.workingIds.contains(call.id);

    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        call.name.isNotEmpty ? call.name : 'Unnamed',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                _infoRow(
                  Icons.badge_outlined,
                  call.agent.isNotEmpty ? call.agent : 'Unassigned',
                  Colors.indigo,
                ),
                const SizedBox(height: 6),

                _infoRow(
                  Icons.campaign_outlined,
                  call.sourceName,
                  Colors.orange,
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(call.statusName),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionIcon(
                      bg: const Color(0xFF22C55E),
                      icon: FontAwesomeIcons.whatsapp,
                      onTap: () => HyperLinksNew.openWhatsApp(
                        call.phone,
                        'Hi ${call.name}, ',
                      ),
                    ),

                    _actionIcon(
                      bg: Colors.white,
                      border: Border.all(color: Colors.black26),
                      icon: Icons.copy_rounded,
                      iconColor: Colors.grey.shade800,
                      onTap: () => Helpers.copyClipboard(call.phone),
                    ),
                    _actionIcon(
                      bg: Colors.purple.shade50,
                      border: Border.all(color: Colors.purple.shade200),
                      icon: Icons.swap_horiz,
                      iconColor: Colors.purple,
                      onTap: busy ? () {} : () => _pickStatus(context, ctrl),
                    ),
                    _actionIcon(
                      bg: Colors.teal.shade50,
                      border: Border.all(color: Colors.teal.shade200),
                      icon: Icons.person_add_alt_1,
                      iconColor: Colors.teal,
                      onTap: busy
                          ? () {}
                          : () => _confirmConvert(context, ctrl),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              right: 0,
              child: InkWell(
                onTap: () => HyperLinksNew.openDialer(call.phone),
                borderRadius: BorderRadius.circular(50),
                child: const Icon(
                  Icons.call,
                  size: 28,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Optionally show convert ribbon
    if (!showConvert) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          left: 0,
          right: 0,
          bottom: -14,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Convert',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---- Helpers ----
  Widget _infoRow(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    if (status.isEmpty) return const SizedBox.shrink();

    final lowerStatus = status.toLowerCase();
    final color =
        CallConstants.statusColors[lowerStatus] ??
        CallConstants.defaultStatusColor;
    final icon =
        CallConstants.statusIcons[lowerStatus] ??
        CallConstants.defaultStatusIcon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _actionIcon({
    required Color bg,
    Border? border,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 22),
      ),
    );
  }

  // --- Status picker & conversion ---
  void _pickStatus(BuildContext context, ColdCallController ctrl) {
    final filters = Get.isRegistered<FiltersController>()
        ? Get.find<FiltersController>()
        : Get.put(FiltersController(), permanent: true);

    if (filters.statusList.isEmpty && !filters.isLoading.value) {
      filters.fetchStatus();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Obx(() {
            if (filters.isLoading.value && filters.statusList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = filters.statusList;
            if (list.isEmpty) {
              return const Center(child: Text('No statuses available'));
            }

            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey[200], height: 1),
              itemBuilder: (_, i) {
                final s = list[i];
                return ListTile(
                  title: Text(s.name),
                  trailing: _statusDot(s.color),
                  onTap: () async {
                    Navigator.pop(context);
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
    );
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

  void _confirmConvert(BuildContext context, ColdCallController ctrl) {
    Get.defaultDialog(
      title: 'Convert to Lead?',
      middleText: 'This will create a lead from this cold call.',
      textCancel: 'Cancel',
      textConfirm: 'Convert',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await ctrl.convertColdCallToLead(callId: call.id);
      },
    );
  }
}
