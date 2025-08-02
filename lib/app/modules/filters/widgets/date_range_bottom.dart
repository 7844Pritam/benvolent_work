import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';

class DateRangePickerBottomSheet extends StatefulWidget {
  final Function(DateTime, DateTime) onApply;

  const DateRangePickerBottomSheet({super.key, required this.onApply});

  @override
  State<DateRangePickerBottomSheet> createState() =>
      _DateRangePickerBottomSheetState();
}

class _DateRangePickerBottomSheetState
    extends State<DateRangePickerBottomSheet> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 0);

  Future<void> selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.45,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppThemes.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                ),
              ),
              Text(
                "Select Date & Time Range",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildBoxTile(
                      label: "Start Date",
                      value: DateFormat.yMMMd().format(startDate),
                      onTap: () => selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBoxTile(
                      label: "End Date",
                      value: DateFormat.yMMMd().format(endDate),
                      onTap: () => selectDate(context, false),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildBoxTile(
              //         label: "Start Time",
              //         value: formatTime(startTime),
              //         onTap: () => selectTime(context, true),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: _buildBoxTile(
              //         label: "End Time",
              //         value: formatTime(endTime),
              //         onTap: () => selectTime(context, false),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  widget.onApply(startDate, endDate);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.primaryColor,
                  foregroundColor: AppThemes.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBoxTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(35, 16, 56, 67),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(143, 25, 88, 106)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppThemes.darkGrey),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppThemes.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
