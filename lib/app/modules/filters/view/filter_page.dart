import 'package:benevolent_crm_app/app/modules/converted_call/controller/converted_call_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/widgets/date_range_bottom.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';

import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  final String flag;
  const FilterPage({super.key, required this.flag});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedAgent = '';
  Set<int> selectedStatuses = {};
  Set<int> selectedCampaigns = {};
  String selectedDateRange = '';
  String keyword = '';
  String activeFilter = 'Agent';

  final FiltersController _filtersController = Get.put(FiltersController());

  final List<String> filterOptions = [
    'Agent',
    'Date Range',
    'Status',
    'Campaign',
    'Keyword',
  ];

  void clearFilters() {
    setState(() {
      selectedAgent = '';
      selectedStatuses.clear();
      selectedCampaigns.clear();
      selectedDateRange = '';
      keyword = '';
    });
  }

  Widget buildRightPanel() {
    switch (activeFilter) {
      case 'Agent':
        return Column(
          children: [
            'John Mitchell',
            'Sarah Johnson',
            'Michael Chen',
          ].map((name) => agentSingleSelectTile(name)).toList(),
        );

      case 'Status':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.statusList
                  .map(
                    (status) => multiSelectTile(
                      label: status.name,
                      selectedSet: selectedStatuses,
                      id: 1,
                    ),
                  )
                  .toList(),
            ),
          );
        });

      case 'Campaign':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.campaignList
                  .map(
                    (data) => multiSelectTile(
                      label: data.name,
                      id: data.id,
                      selectedSet: selectedCampaigns,
                    ),
                  )
                  .toList(),
            ),
          );
        });

      case 'Date Range':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DateRangePickerBottomSheet(
                    onApply: (start, end) {
                      setState(() {
                        selectedDateRange =
                            '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end)}';
                      });
                    },
                  ),
                );
              },
              icon: const Icon(Icons.date_range),
              label: const Text("Pick Date Range"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.08),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 16),
            if (selectedDateRange.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        selectedDateRange,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDateRange = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white60,
                      ),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
          ],
        );

      case 'Keyword':
        return TextField(
          onChanged: (val) => setState(() => keyword = val),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter keyword...',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        );

      default:
        return const Center(
          child: Text(
            'Select a filter option',
            style: TextStyle(color: AppColors.grey),
          ),
        );
    }
  }

  Widget agentSingleSelectTile(String name) {
    final isSelected = selectedAgent == name;
    return GestureDetector(
      onTap: () => setState(() => selectedAgent = name),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentColor.withOpacity(0.2)
              : AppColors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentColor : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.greyLight,
          ),
        ),
      ),
    );
  }

  Widget multiSelectTile({
    required String label,
    required Set<int> selectedSet,
    required int id,
  }) {
    print(selectedSet);
    final isSelected = selectedSet.contains(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSet.remove(id);
          } else {
            selectedSet.add(id);
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.accentColor.withOpacity(0.2)
              : AppColors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected ? AppColors.accentColor : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.greyLight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  color: AppColors.primaryColor.withOpacity(0.95),
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: filterOptions.map((option) {
                      final isActive = activeFilter == option;
                      return GestureDetector(
                        onTap: () => setState(() => activeFilter = option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.accentColor.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.white
                                  : AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.white.withOpacity(0.05),
                    child: buildRightPanel(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 16,
                  ),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final controller = Get.find<LeadsController>();
                    controller.applyFilters(
                      LeadRequestModel(
                        agentId: "",
                        fromDate: "",
                        toDate: "",
                        status: "",
                        campaign: selectedCampaigns.isNotEmpty
                            ? selectedCampaigns.first.toString()
                            : "",
                        keyword: "",
                        developerId: '',
                        propertyId: '',
                        priority: '',
                      ),
                    );
                    Get.back();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    foregroundColor: AppColors.primaryColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
