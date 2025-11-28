import 'package:benevolent_crm_app/app/modules/campaign_summary/controllers/campaign_summary_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/widgets/date_range_bottom.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CampaignFilterBottomSheet extends StatefulWidget {
  const CampaignFilterBottomSheet({super.key});

  @override
  State<CampaignFilterBottomSheet> createState() =>
      _CampaignFilterBottomSheetState();
}

class _CampaignFilterBottomSheetState extends State<CampaignFilterBottomSheet> {
  final CampaignSummaryController _controller = Get.find<CampaignSummaryController>();
  final FiltersController _filtersController = Get.find<FiltersController>();

  // Local state to hold selections before applying
  late Set<int> _selectedCampaigns;
  late Set<int> _selectedSources;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedDateRange = '';

  // Track active tab/section
  String _activeSection = 'Campaign'; // Campaign, Source, Date Range

  @override
  void initState() {
    super.initState();
    // Initialize with current controller state
    _selectedCampaigns = Set.from(_controller.selectedCampaigns);
    _selectedSources = Set.from(_controller.selectedSources);
    _fromDate = _controller.fromDate.value;
    _toDate = _controller.toDate.value;
    
    if (_fromDate != null && _toDate != null) {
      _selectedDateRange = '${DateFormat.yMMMd().format(_fromDate!)} - ${DateFormat.yMMMd().format(_toDate!)}';
    }

    // Ensure we have campaigns loaded
    if (_filtersController.campaignList.isEmpty) {
      _filtersController.fetchCampaigns();
    }
    
    // If we have exactly one campaign selected, fetch sources for it
    if (_selectedCampaigns.length == 1) {
       _filtersController.fetchSources(campaignId: _selectedCampaigns.first.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body
          Expanded(
            child: Row(
              children: [
                // Left Side Navigation
                Container(
                  width: 120,
                  color: Colors.grey.shade50,
                  child: ListView(
                    children: [
                      _buildNavItem('Campaign'),
                      _buildNavItem('Source'),
                      _buildNavItem('Date Range'),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                // Right Side Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildActiveContent(),
                  ),
                ),
              ],
            ),
          ),

          // Footer Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCampaigns.clear();
                        _selectedSources.clear();
                        _fromDate = null;
                        _toDate = null;
                        _selectedDateRange = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller.applyFilters(
                        campaigns: _selectedCampaigns,
                        sources: _selectedSources,
                        start: _fromDate,
                        end: _toDate,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Apply Filters",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title) {
    final isActive = _activeSection == title;
    return InkWell(
      onTap: () => setState(() => _activeSection = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        color: isActive ? Colors.white : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primaryColor : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    switch (_activeSection) {
      case 'Campaign':
        return _buildCampaignList();
      case 'Source':
        return _buildSourceList();
      case 'Date Range':
        return _buildDateRangePicker();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCampaignList() {
    return Obx(() {
      if (_filtersController.isLoading.value && _filtersController.campaignList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: _filtersController.campaignList.length,
        itemBuilder: (context, index) {
          final campaign = _filtersController.campaignList[index];
          final isSelected = _selectedCampaigns.contains(campaign.id);
          return CheckboxListTile(
            value: isSelected,
            title: Text(campaign.name),
            activeColor: AppColors.primaryColor,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedCampaigns.add(campaign.id);
                } else {
                  _selectedCampaigns.remove(campaign.id);
                }
                
                // Reset sources if campaign selection changes to avoid invalid states
                // Logic: If multiple campaigns or 0 campaigns, we can't easily show sources for just one without ambiguity
                // For now, if selection changes, let's clear sources to be safe or re-fetch if exactly one is selected
                _selectedSources.clear();
                if (_selectedCampaigns.length == 1) {
                  _filtersController.fetchSources(campaignId: _selectedCampaigns.first.toString());
                } else {
                  _filtersController.sourceList.clear();
                }
              });
            },
          );
        },
      );
    });
  }

  Widget _buildSourceList() {
    if (_selectedCampaigns.isEmpty) {
      return const Center(child: Text("Please select a campaign first."));
    }
    if (_selectedCampaigns.length > 1) {
      return const Center(child: Text("Please select only one campaign to filter by source."));
    }

    return Obx(() {
      if (_filtersController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_filtersController.sourceList.isEmpty) {
        return const Center(child: Text("No sources found for this campaign."));
      }
      return ListView.builder(
        itemCount: _filtersController.sourceList.length,
        itemBuilder: (context, index) {
          final source = _filtersController.sourceList[index];
          final isSelected = _selectedSources.contains(source.id);
          return CheckboxListTile(
            value: isSelected,
            title: Text(source.name),
            activeColor: AppColors.primaryColor,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedSources.add(source.id);
                } else {
                  _selectedSources.remove(source.id);
                }
              });
            },
          );
        },
      );
    });
  }

  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Date Range",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => DateRangePickerBottomSheet(
                onApply: (start, end) {
                  setState(() {
                    _fromDate = start;
                    _toDate = end;
                    _selectedDateRange =
                        '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end)}';
                  });
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryColor),
                const SizedBox(width: 12),
                Text(
                  _selectedDateRange.isNotEmpty ? _selectedDateRange : "Tap to select date range",
                  style: TextStyle(
                    color: _selectedDateRange.isNotEmpty ? Colors.black87 : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedDateRange.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _fromDate = null;
                  _toDate = null;
                  _selectedDateRange = '';
                });
              },
              icon: const Icon(Icons.clear, size: 18),
              label: const Text("Clear Date"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
      ],
    );
  }
}
