import 'dart:io';

import 'package:benevolent_crm_app/app/modules/auth/views/create_password_screen.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/views/cold_call_page.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/view/all_leads_page.dart';
import 'package:benevolent_crm_app/app/modules/notification/controller/notification_controller.dart';
import 'package:benevolent_crm_app/app/modules/notification/view/notification_page.dart';
import 'package:benevolent_crm_app/app/modules/profile/view/profile_page.dart';
import 'package:benevolent_crm_app/app/widgets/confirm_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  // ignore: unused_field
  final NotificationController _c = Get.put(NotificationController());

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
          final email = controller.emailController.text;
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
                      color: AppThemes.textColorWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'User ID: $userId',
                    style: const TextStyle(
                      color: AppThemes.textColorWhite,
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
                  iconDisabledColor: Colors.white,

                  underline: Container(),
                  dropdownColor: AppThemes.primaryColor,
                  iconEnabledColor: AppThemes.white,
                  style: const TextStyle(
                    color: AppThemes.textColorSecondary,
                    fontSize: 14,
                  ),
                  isExpanded: true,
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(color: Colors.white),
                      ),
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
                leading: const Icon(
                  LucideIcons.layoutDashboard,
                  color: Colors.white,
                ),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _advancedDrawerController.toggleDrawer(),
              ),
              ListTile(
                leading: const Icon(LucideIcons.user, color: Colors.white),
                title: const Text(
                  'Leads',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.to(AllLeadsPage()),
              ),
              ListTile(
                leading: const Icon(LucideIcons.phoneCall, color: Colors.white),
                title: const Text(
                  'Cold Calls',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.to(ColdCallPage()),
              ),
              ListTile(
                leading: const Icon(
                  LucideIcons.checkCircle2,
                  color: Colors.white,
                ),
                title: const Text(
                  'Converted Cold Calls',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.to(ConvertedCallsPage()),
              ),
              ListTile(
                leading: const Icon(LucideIcons.bell, color: Colors.white),
                title: const Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.to(NotificationPage()),
              ),
              ListTile(
                leading: const Icon(LucideIcons.eye, color: Colors.white),
                title: const Text(
                  'Change Passworod',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () =>
                    Get.to(CreatePasswordScreen(email: email, flag: 2)),
              ),
              ListTile(
                leading: const Icon(LucideIcons.logOut, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: _logout,
              ),
              const SizedBox(height: 5),
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
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          title: const Text('Dashboard'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _advancedDrawerController.showDrawer,
          ),
          actions: [
            Obx(() {
              final n = Get.find<NotificationController>();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.notifications),
                    color: Colors.white,
                    onPressed: () async {
                      await Get.to(() => NotificationPage());
                      // Optionally refresh or mark read after visiting:
                      // n.markAllRead();
                      n.refreshNotifications();
                    },
                  ),
                  if (n.unreadCount.value > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: _CountBadge(count: n.unreadCount.value),
                    ),
                ],
              );
            }),
            const SizedBox(width: 4),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () => Get.to(() => UserProfilePage()),
            ),
          ],
        ),

        body: widget.child,
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final display = count > 99 ? '99+' : '$count';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, anim) =>
          ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(display),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        child: Text(
          display,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
