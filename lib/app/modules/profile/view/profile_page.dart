import 'dart:io';

import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfilePage> {
  final ProfileController profilecontroller = Get.find<ProfileController>();
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
                  profilecontroller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  profilecontroller.pickImage(ImageSource.gallery);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Obx(() {
          if (profilecontroller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return Obx(() {
            return Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),

                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    profilecontroller
                                        .pickedImageFilePath
                                        .isNotEmpty
                                    ? FileImage(
                                        File(
                                          profilecontroller
                                              .pickedImageFilePath
                                              .value,
                                        ),
                                      )
                                    : profilecontroller.imageUrlController.text
                                          .startsWith("http")
                                    ? NetworkImage(
                                        profilecontroller
                                            .imageUrlController
                                            .text,
                                      )
                                    : FileImage(
                                            File(
                                              profilecontroller
                                                  .imageUrlController
                                                  .text,
                                            ),
                                          )
                                          as ImageProvider,
                              ),

                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: InkWell(
                                  onTap: () => _showImageSourceDialog(context),
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

                          InfoRow(
                            label: "Name",
                            value:
                                "${profilecontroller.firstNameController.text} ${profilecontroller.lastNameController.text}",
                          ),

                          InfoRow(
                            label: "Email",
                            value: profilecontroller.emailController.text,
                          ),

                          const Divider(height: 32),

                          /// Name
                          buildEditableField(
                            "First Name",
                            profilecontroller.firstNameController,
                          ),

                          /// Email
                          buildEditableField(
                            "Email",
                            profilecontroller.emailController,
                            validator: Validators.validateEmail,
                          ),

                          buildEditableField(
                            "Phone",
                            profilecontroller.phoneController,
                          ),

                          buildEditableField(
                            "Alt Contact",
                            profilecontroller.alternateController,
                          ),

                          buildEditableField(
                            "Address",
                            profilecontroller.addressController,
                          ),
                          CustomButton(
                            text: "Update",
                            onPressed: () => profilecontroller.updateProfile(),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  if (profilecontroller.isUpdating.value ||
                      profilecontroller.isUploadingImage.value)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black38,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
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
