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
                      id: status.id,
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
              icon: const Icon(Icons.date_range, color: Colors.white),
              label: const Text(
                "Pick Date Range",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),

            const SizedBox(height: 16),
            if (selectedDateRange.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        selectedDateRange,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => selectedDateRange = '');
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black54,
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
          decoration: InputDecoration(
            hintText: 'Enter keyword...',
            filled: true,
            fillColor: Colors.grey[100],
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
        return const Center(child: Text('Select a filter option'));
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
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
            fontWeight: FontWeight.w500,
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
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.green.shade900 : Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Filter", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  color: Colors.grey.shade100,
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
                                ? Colors.blue.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.blue.shade800
                                  : Colors.black87,
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
                    color: Colors.white,
                    child: buildRightPanel(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(Icons.clear, color: Colors.black54),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final controller = widget.flag == "fromConvertedCalls"
                        ? Get.find<ConvertedCallController>()
                        : Get.find<LeadsController>();

                    // await controller.applyFilters(
                    //   LeadRequestModel(
                    //     agentId: selectedAgent,
                    //     fromDate: '',
                    //     toDate: '',
                    //     status: '',
                    //     campaign: selectedCampaigns.isNotEmpty
                    //         ? selectedCampaigns.first.toString()
                    //         : '',
                    //     keyword: keyword,
                    //     developerId: '',
                    //     propertyId: '',
                    //     priority: '',
                    //   ),
                    // );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
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
