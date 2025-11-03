import 'package:benevolent_crm_app/app/modules/converted_call/constants/call_constants.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:benevolent_crm_app/app/utils/helpers.dart';
import 'package:benevolent_crm_app/app/utils/hyper_links/hyper_links.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final bool showAccept;

  const LeadCard({super.key, required this.lead, this.showAccept = false});

  @override
  Widget build(BuildContext context) {
    final LeadsController controller = Get.find<LeadsController>();

    return Obx(() {
      final currentLead = controller.leads.firstWhere(
        (l) => l.id == lead.id,
        orElse: () => lead,
      );

      print("status name of lead = ${currentLead.statusName}");

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
                  // Lead ID
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lead ID : ${currentLead.id}',
                          style: TextStyles.Text14400.copyWith(
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Text(
                    currentLead.name,
                    style: TextStyles.Text18700.copyWith(),
                  ),
                  const SizedBox(height: 8),

                  // Agent
                  _infoRow(
                    Icons.groups_2_outlined,
                    currentLead.agent,
                    Colors.pink,
                  ),
                  const SizedBox(height: 6),

                  // Campaign
                  _infoRow(
                    Icons.campaign_outlined,
                    currentLead.campaignName,
                    Colors.green,
                  ),
                  const SizedBox(height: 10),

                  // Divider + Status Chip
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.black12, thickness: 1),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        (currentLead.statusName.trim().isNotEmpty)
                            ? currentLead.statusName
                            : "Not Set",
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionIcon(
                        bg: const Color.fromARGB(255, 42, 100, 64),
                        icon: FontAwesomeIcons.whatsapp,
                        onTap: () => HyperLinksNew.openWhatsApp(
                          currentLead.phone,
                          currentLead.name,
                        ),
                      ),
                      _actionIcon(
                        bg: Colors.white,
                        border: Border.all(color: Colors.black26),
                        icon: Icons.email_outlined,
                        iconColor: Colors.green.shade700,
                        onTap: () => HyperLinksNew.openEmail(
                          currentLead.email,
                          currentLead.name,
                        ),
                      ),
                      _actionIcon(
                        bg: Colors.white,
                        border: Border.all(color: Colors.black26),
                        icon: Icons.copy_rounded,
                        iconColor: Colors.green.shade700,
                        onTap: () => Helpers.copyClipboard(currentLead.phone),
                      ),
                    ],
                  ),
                ],
              ),

              // Call button
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: () => HyperLinksNew.openDialer(currentLead.phone),
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

      if (!showAccept) return card;

      // Add Accept ribbon
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Accept',
                  style: TextStyles.Text16700.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    });
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
            style: TextStyles.Text14400.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final lowerStatus = status.toLowerCase();
    final color =
        CallConstants.statusColors[lowerStatus] ??
        CallConstants.defaultStatusColor;
    final icon =
        CallConstants.statusIcons[lowerStatus] ??
        CallConstants.defaultStatusIcon;

    if (status.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(status, style: TextStyles.Text13500.copyWith(color: color)),
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
}
