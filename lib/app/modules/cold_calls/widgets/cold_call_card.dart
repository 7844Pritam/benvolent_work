import 'dart:convert';

import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/dialog_box.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/constants/call_constants.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:benevolent_crm_app/app/utils/helpers.dart';
import 'package:benevolent_crm_app/app/utils/hyper_links/hyper_links.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../modals/cold_call_model.dart';
import '../controllers/cold_call_controller.dart';

class ColdCallCard extends StatefulWidget {
  final ColdCall call;
  final bool showConvert;

  const ColdCallCard({super.key, required this.call, this.showConvert = false});

  @override
  State<ColdCallCard> createState() => _ColdCallCardState();
}

class _ColdCallCardState extends State<ColdCallCard> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await Helpers.isAdmin();
    print("ColdCallCard - Admin check result: $isAdmin");
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<ColdCallController>();
    final busy = ctrl.workingIds.contains(widget.call.id);
    final ProfileController _profileController = Get.find<ProfileController>();

    print("sldkjfldsjfsdf");

    print("id coming from profile");
    final profile = _profileController.profile.value;
    if (profile != null) {
      print(const JsonEncoder.withIndent('  ').convert(profile.toJson()));
    } else {
      print("⚠️ Profile not loaded yet!");
    }
    print("profile id here here r");
    print(_profileController.profile.value!.id);

    print("id is coming from converted card data ");
    print(ctrl.coldCalls.map((value) => print(value.agent_id)));
    final isOwner =
        '${_profileController.profile.value!.id}' == widget.call.agent_id.toString();
    final canAccess = _isAdmin || isOwner;
    
    print("ColdCallCard - isOwner: $isOwner, _isAdmin: $_isAdmin, canAccess: $canAccess");

    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                        widget.call.name.isNotEmpty ? widget.call.name : 'Unnamed',
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
                  widget.call.agent.isNotEmpty ? widget.call.agent : 'Unassigned',
                  Colors.indigo,
                ),
                const SizedBox(height: 6),

                _infoRow(
                  Icons.campaign_outlined,
                  widget.call.sourceName,
                  Colors.orange,
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(widget.call.statusName),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionIcon(
                      bg: const Color.fromARGB(
                        255,
                        22,
                        122,
                        59,
                      ).withOpacity(canAccess ? 1 : 0.4),
                      icon: FontAwesomeIcons.whatsapp,
                      onTap: canAccess
                          ? () => HyperLinksNew.openWhatsApp(
                              widget.call.phone,
                              'Hi ${widget.call.name}, ',
                            )
                          : () => _showNotAllowedPopup(),
                    ),
                    _actionIcon(
                      bg: Colors.white.withOpacity(canAccess ? 1 : 0.4),
                      border: Border.all(color: Colors.black26),
                      icon: Icons.copy_rounded,
                      iconColor: Colors.grey.shade800,
                      onTap: canAccess
                          ? () => Helpers.copyClipboard(widget.call.phone)
                          : () => _showNotAllowedPopup(),
                    ),
                    _actionIcon(
                      bg: Colors.purple.shade50.withOpacity(canAccess ? 1 : 0.4),
                      border: Border.all(color: Colors.purple.shade200),
                      icon: Icons.swap_horiz,
                      iconColor: Colors.purple,
                      onTap: canAccess
                          ? (busy ? () {} : () => _pickStatus(context, ctrl, widget.call))
                          : () => _showNotAllowedPopup(),
                    ),
                    _actionIcon(
                      bg: const Color.fromARGB(
                        255,
                        185,
                        216,
                        216,
                      ).withOpacity(canAccess ? 1 : 0.4),
                      border: Border.all(color: Colors.teal.shade200),
                      icon: Icons.person_add_alt_1,
                      iconColor: Colors.teal,
                      onTap: canAccess
                          ? (busy
                                ? () {}
                                : () => _confirmConvert(context, ctrl, widget.call))
                          : () => _showNotAllowedPopup(),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  if (!canAccess) {
                    _showNotAllowedPopup();
                  } else {
                    HyperLinksNew.openDialer(widget.call.phone);
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Icon(
                  Icons.call,
                  size: 28,
                  color: canAccess
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );

        // Optionally show convert ribbon
        if (!widget.showConvert) return card;

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

  void _pickStatus(BuildContext context, ColdCallController ctrl, ColdCall call) {
    final filters = Get.isRegistered<FiltersController>()
        ? Get.find<FiltersController>()
        : Get.put(FiltersController(), permanent: true);

    if (filters.statusList.isEmpty && !filters.isLoading.value) {
      filters.fetchStatus();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Expanded(
                    child: Obx(() {
                      if (filters.isLoading.value &&
                          filters.statusList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final list = filters.statusList;
                      if (list.isEmpty) {
                        return const Center(
                          child: Text('No statuses available'),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey[200], height: 1),
                        itemBuilder: (_, i) {
                          final s = list[i];
                          return ListTile(
                            title: Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await ctrl.changeColdCallStatus(
                                callId: widget.call.id,
                                statusId: s.id,
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmConvert(BuildContext context, ColdCallController ctrl, ColdCall call) {
    Get.dialog(
      ConfirmConvertDialog(
        onConfirm: () async {
          await ctrl.convertColdCallToLead(callId: widget.call.id);
          Get.snackbar(
            'Converted',
            '${widget.call.name} is now a lead!',
            backgroundColor: AppColors.green.withOpacity(0.1),
            colorText: AppColors.primaryColor,
            icon: const Icon(Icons.check_circle, color: AppColors.green),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(12),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showNotAllowedPopup() {
    CustomSnackbar.show(
      title: 'Access Denied',
      message:
          'This action is not allowed. The cold call is not assigned to you.',
    );
  }
}
