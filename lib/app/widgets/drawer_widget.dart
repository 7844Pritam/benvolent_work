import 'dart:io';

import 'package:benevolent_crm_app/app/modules/profile/view/profile_page.dart';
import 'package:benevolent_crm_app/app/widgets/bottom_bar.dart';
import 'package:benevolent_crm_app/app/widgets/confirm_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';

class ModernDrawerWrapper extends StatefulWidget {
  final Widget child;
  const ModernDrawerWrapper({super.key, required this.child});

  @override
  State<ModernDrawerWrapper> createState() => _ModernDrawerWrapperState();
}

class _ModernDrawerWrapperState extends State<ModernDrawerWrapper> {
  final _advancedDrawerController = AdvancedDrawerController();
  final box = GetStorage();
  final ProfileController controller = Get.find<ProfileController>();
  String _appVersion = '';

  final List<String> _statusOptions = [
    'Available',
    'In Meeting',
    'Sick Leave',
    'Annual Leave',
  ];

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "v${info.version}";
    });
  }

  void _logout() {
    box.erase();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: AppThemes.primaryColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      openRatio: 0.75,
      openScale: 0.85,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      drawer: SafeArea(
        child: Obx(() {
          final profile = controller.profile.value;
          final firstName = controller.firstNameController.text;
          final lastName = controller.lastNameController.text;
          final userId = controller.userIdController.text;
          final availability = profile?.availability ?? 'Available';

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  final imagePath = controller.pickedImageFilePath.isNotEmpty
                      ? controller.pickedImageFilePath.value
                      : controller.imageUrlController.text;

                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.black,
                      child: InteractiveViewer(
                        child:
                            controller.pickedImageFilePath.isNotEmpty ||
                                !imagePath.startsWith('http')
                            ? Image.file(File(imagePath))
                            : Image.network(imagePath),
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: controller.pickedImageFilePath.isNotEmpty
                        ? Image.file(
                            File(controller.pickedImageFilePath.value),
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          )
                        : controller.imageUrlController.text.startsWith('http')
                        ? Image.network(
                            controller.imageUrlController.text,
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          )
                        : Image.file(
                            File(controller.imageUrlController.text),
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hello, $firstName $lastName',
                    style: const TextStyle(
                      color: AppThemes.textColorPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'User ID: $userId',
                    style: const TextStyle(
                      color: AppThemes.textColorSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed('/profile'),
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: availability,
                  underline: Container(),
                  dropdownColor: AppThemes.primaryColor,
                  iconEnabledColor: AppThemes.textColorSecondary,
                  style: const TextStyle(
                    color: AppThemes.textColorSecondary,
                    fontSize: 14,
                  ),
                  isExpanded: true,
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != availability) {
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmStatusDialog(
                          newStatus: newValue,
                          onConfirm: () =>
                              controller.changeAvailability(newValue),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(color: Colors.white38, height: 32),
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.white),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.toNamed('/dashboard'),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.toNamed('/about'),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: _logout,
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  _appVersion,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        }),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _advancedDrawerController.showDrawer,
          ),
          actions: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            SizedBox(width: 4),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Get.to(UserProfileCard());
              },
            ),
          ],
        ),
        body: widget.child,
      ),
    );
  }
}
