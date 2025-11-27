import 'dart:io';

import 'package:benevolent_crm_app/app/modules/campaign_summary/controllers/campaign_summary_controller.dart';
import 'package:benevolent_crm_app/app/modules/campaign_summary/views/widgets/campaign_filter_bottom_sheet.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignOptionsBottomSheet extends StatelessWidget {
  final CampaignSummaryController controller = Get.find<CampaignSummaryController>();
  final String exampleImagePath = '/mnt/data/A_screenshot_of_a_Flutter_application_displays_a_b.png';

  CampaignOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final imageFile = File(exampleImagePath);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle / Title
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Text("Campaign Options", style: TextStyles.Text18700),
            const SizedBox(height: 18),

            // Horizontal Scrollable Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildImageOption(
                    label: "Filter",
                    imageWidget: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        size: 36,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      Get.back(); // Close current sheet
                      Get.bottomSheet(
                        const CampaignFilterBottomSheet(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildImageOption(
                    label: "Reload Summary",
                    imageWidget: imageFile.existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              imageFile,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _placeholderImageBox(),
                    onTap: () async {
                      await controller.fetchCampaignSummary();
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Data refreshed successfully",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildImageOption(
                    label: "Export CSV",
                    imageWidget: imageFile.existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              imageFile,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _placeholderImageBox(),
                    onTap: () async {
                      await controller.exportSummaryAsCsv?.call();
                      Get.back();
                      Get.snackbar(
                        "Export",
                        "CSV export started",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildImageOption(
                    label: "View Details",
                    imageWidget: imageFile.existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              imageFile,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _placeholderImageBox(),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        "Open",
                        "Opening details...",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildImageOption(
                    label: "Close",
                    imageWidget: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 36,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Tap an option to perform action",
              style: TextStyles.Text14500?.copyWith(
                    color: Colors.grey.shade600,
                  ) ??
                  TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required String label,
    required Widget imageWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: imageWidget,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImageBox() {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(
        Icons.image_not_supported,
        size: 36,
        color: Colors.grey,
      ),
    );
  }
}
