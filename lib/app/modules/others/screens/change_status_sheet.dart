import 'package:benevolent_crm_app/app/modules/others/controller/change_status_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:benevolent_crm_app/app/widgets/custom_select_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeStatusSheet extends StatefulWidget {
  final int callId;
  const ChangeStatusSheet({super.key, required this.callId});

  @override
  State<ChangeStatusSheet> createState() => _ChangeStatusSheetState();
}

class _ChangeStatusSheetState extends State<ChangeStatusSheet> {
  final _controller = Get.put(ChangeStatusController());
  final _filters = Get.find<FiltersController>();

  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedStatusId = '';
  String _selectedSubStatusId = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Obx(() {
            final isLoading = _filters.isLoading.value;
            final statuses = _filters.statusList;
            // Filter sub-statuses for the currently selected status
            final subStatuses = _filters.subStatusesFor(_selectedStatusId);

            /// Bootstrap defaults once data is present
            if (!isLoading &&
                statuses.isNotEmpty &&
                _selectedStatusId.isEmpty) {
              _selectedStatusId = statuses.first.id.toString();
            }
            if (!isLoading && _selectedStatusId.isNotEmpty) {
              if (subStatuses.isNotEmpty) {
                // if selected subStatus is not in the filtered list, pick the first one
                final containsSelected = subStatuses.any(
                  (s) => s.id.toString() == _selectedSubStatusId,
                );
                if (!containsSelected) {
                  _selectedSubStatusId = subStatuses.first.id.toString();
                }
              } else {
                _selectedSubStatusId = '';
              }
            }

            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      height: 5,
                      width: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    "Change Status",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (isLoading) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ] else ...[
                    // STATUS
                    CustomSelectField<String>(
                      label: 'Status',
                      value: _selectedStatusId.isEmpty
                          ? null
                          : _selectedStatusId,
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() {
                          _selectedStatusId = val;
                          // Reset sub-status when status changes
                          final fresh = _filters.subStatusesFor(
                            _selectedStatusId,
                          );
                          _selectedSubStatusId = fresh.isNotEmpty
                              ? fresh.first.id.toString()
                              : '';
                        });
                      },
                      items: statuses
                          .map(
                            (status) => DropdownMenuItem<String>(
                              value: status.id.toString(),
                              child: Text(status.name),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    // SUB-STATUS (dependent)
                    IgnorePointer(
                      ignoring: subStatuses.isEmpty,
                      child: Opacity(
                        opacity: subStatuses.isEmpty ? 0.6 : 1,
                        child: CustomSelectField<String>(
                          label: subStatuses.isEmpty
                              ? 'Sub Status (none available)'
                              : 'Sub Status',
                          value: _selectedSubStatusId.isEmpty
                              ? null
                              : _selectedSubStatusId,
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() => _selectedSubStatusId = val);
                          },
                          items: subStatuses
                              .map(
                                (s) => DropdownMenuItem<String>(
                                  value: s.id.toString(),
                                  child: Text(s.subName),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // COMMENT
                    CustomInputField(
                      label: "Comment",
                      controller: _commentController,
                      validator: (value) =>
                          Validators.validateEmpty(value, fieldName: "Comment"),
                    ),

                    const SizedBox(height: 24),

                    // SUBMIT
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_selectedStatusId.isEmpty) return;

                          await _controller.changeStatus(
                            widget.callId,
                            _selectedStatusId,
                            _selectedSubStatusId,
                            _commentController.text.trim(),
                          );
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
