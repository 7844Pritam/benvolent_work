import 'dart:io';

import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileCard extends StatefulWidget {
  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  bool isEditMode = false;

  final ProfileController controller = Get.find<ProfileController>();
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(isEditMode ? Icons.save : Icons.edit),
                              color: AppThemes.primaryColor,
                              onPressed: () {
                                if (isEditMode) {
                                  controller.updateProfile();
                                }
                                setState(() {
                                  isEditMode = !isEditMode;
                                });
                              },
                            ),
                          ),

                          /// Avatar + Edit Icon
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    controller.pickedImageFilePath.isNotEmpty
                                    ? FileImage(
                                        File(
                                          controller.pickedImageFilePath.value,
                                        ),
                                      )
                                    : controller.imageUrlController.text
                                          .startsWith("http")
                                    ? NetworkImage(
                                        controller.imageUrlController.text,
                                      )
                                    : FileImage(
                                            File(
                                              controller
                                                  .imageUrlController
                                                  .text,
                                            ),
                                          )
                                          as ImageProvider,
                              ),
                              if (isEditMode)
                                Positioned(
                                  bottom: 0,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () =>
                                        _showImageSourceDialog(context),
                                    child: const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// Name
                          isEditMode
                              ? buildEditableField(
                                  "First Name",
                                  controller.firstNameController,
                                )
                              : buildReadOnlyText(
                                  "${controller.firstNameController.text} ${controller.lastNameController.text}",
                                  context,
                                  isTitle: true,
                                ),

                          isEditMode
                              ? buildEditableField(
                                  "Last Name",
                                  controller.lastNameController,
                                )
                              : const SizedBox(),

                          const SizedBox(height: 8),

                          /// Email
                          isEditMode
                              ? buildEditableField(
                                  "Email",
                                  controller.emailController,
                                  validator: Validators.validateEmail,
                                )
                              : buildReadOnlyText(
                                  controller.emailController.text,
                                  context,
                                  isTitle: false,
                                ),

                          const Divider(height: 30, thickness: 1.2),

                          /// Phone
                          isEditMode
                              ? buildEditableField(
                                  "Phone",
                                  controller.phoneController,
                                )
                              : InfoRow(
                                  label: "Phone",
                                  value:
                                      "+91 ${controller.phoneController.text}",
                                ),

                          isEditMode
                              ? buildEditableField(
                                  "Alt Contact",
                                  controller.alternateController,
                                )
                              : InfoRow(
                                  label: "Alt Contact",
                                  value: controller.userIdController.text,
                                ),

                          isEditMode
                              ? buildEditableField(
                                  "Address",
                                  controller.addressController,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),

                if (controller.isUpdating.value ||
                    controller.isUploadingImage.value)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black38,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            );
          });
        }),
      ),
    );
  }

  Widget buildEditableField(
    String label,
    TextEditingController controller, {
    final String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomInputField(
        controller: controller,
        label: label,
        validator: validator,
      ),
    );
  }

  Widget buildReadOnlyText(
    String value,
    BuildContext context, {
    bool isTitle = false,
  }) {
    return Text(
      value,
      style: TextStyle(
        fontSize: isTitle ? 24 : 16,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
        color: isTitle ? AppThemes.primaryColor : AppThemes.primaryColor,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: AppThemes.lightGrey,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppThemes.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
