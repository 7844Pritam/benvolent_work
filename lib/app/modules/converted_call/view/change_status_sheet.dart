import 'package:benevolent_crm_app/app/modules/converted_call/controller/change_status_controller.dart';
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
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedStatus = '4';
  String _selectedSubStatus = '1';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
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
          child: Form(
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                CustomSelectField<String>(
                  label: 'Status',
                  value: _selectedStatus,
                  onChanged: (val) => setState(() => _selectedStatus = val!),
                  items: const [
                    DropdownMenuItem(value: '4', child: Text('Interested')),
                    DropdownMenuItem(value: '5', child: Text('Not Interested')),
                  ],
                ),
                const SizedBox(height: 16),
                CustomSelectField<String>(
                  label: 'Sub Status',
                  value: _selectedSubStatus,
                  onChanged: (val) => setState(() => _selectedSubStatus = val!),
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Follow-up')),
                    DropdownMenuItem(value: '2', child: Text('Converted')),
                  ],
                ),

                const SizedBox(height: 16),
                CustomInputField(
                  label: "Comment",
                  controller: _commentController,
                  validator: (value) =>
                      Validators.validateEmpty(value, fieldName: "Comment"),
                ),

                const SizedBox(height: 24),

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
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      _controller.changeStatus(
                        widget.callId,
                        _selectedStatus,
                        _selectedSubStatus,
                        _commentController.text,
                      );
                      Get.back();
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
            ),
          ),
        ),
      ),
    );
  }
}
