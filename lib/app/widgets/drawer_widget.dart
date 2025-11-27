import 'dart:io';

import 'package:benevolent_crm_app/app/modules/auth/views/create_password_screen.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/views/cold_call_page.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/view/all_leads_page.dart';
import 'package:benevolent_crm_app/app/modules/notification/controller/notification_controller.dart';
import 'package:benevolent_crm_app/app/modules/notification/view/notification_page.dart';
import 'package:benevolent_crm_app/app/modules/profile/view/profile_page.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/token_storage.dart';
import 'package:benevolent_crm_app/app/widgets/confirm_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:benevolent_crm_app/app/routes/app_routes.dart';

class ModernDrawerWrapper extends StatefulWidget {
  final Widget child;
  const ModernDrawerWrapper({super.key, required this.child});

  @override
  State<ModernDrawerWrapper> createState() => _ModernDrawerWrapperState();
}

class _ModernDrawerWrapperState extends State<ModernDrawerWrapper> {
  final _advancedDrawerController = AdvancedDrawerController();
  final box = GetStorage();
  final ProfileController controller = Get.put(ProfileController());
  final NotificationController _notificationController = Get.put(
    NotificationController(),
  );

  String _appVersion = '';
  bool isAdmin = false;
  bool reportExpanded = false; // For expandable Reports menu

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
    final tokenStorage = TokenStorage();
    final info = await PackageInfo.fromPlatform();
    isAdmin = await tokenStorage.isAdmin();

    setState(() {
      _appVersion = "v${info.version}";
    });
  }

  void _logout() {
    box.erase();
    Get.delete<ProfileController>(force: true);
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: controller.pickedImageFilePath.isNotEmpty
                        ? Image.file(
                            File(controller.pickedImageFilePath.value),
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          )
                        : controller.imageUrlController.text.startsWith('http')
                        ? Image.network(
                            controller.imageUrlController.text,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
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
                    style: (TextStyles.Text18700 ?? const TextStyle()).copyWith(
                      color: AppThemes.textColorWhite,
                    ),
                  ),
                  Text(
                    'User ID: $userId',
                    style: (TextStyles.Text14400 ?? const TextStyle()).copyWith(
                      color: AppThemes.textColorWhite,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(UserProfilePage()),
                child: const Text(
                  'View Profile',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              // Status Dropdown
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
                  iconEnabledColor: Colors.white,
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
                        style: const TextStyle(color: Colors.white),
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

              // MENU ITEMS
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.layoutDashboard,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Dashboard',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () => _advancedDrawerController.toggleDrawer(),
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.user,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Leads',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () => Get.to(AllLeadsPage()),
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.phoneCall,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Cold Calls',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () => Get.to(ColdCallPage()),
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.checkCircle2,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Converted Cold Calls',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () => Get.to(ConvertedCallsPage()),
              ),

              // -------------------------------
              //      REPORTS (EXPANDABLE)
              // -------------------------------
              if (isAdmin) ...[
                ListTile(
                  minTileHeight: 0,
                  leading: const Icon(
                    LucideIcons.pieChart,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text(
                    'Reports',
                    style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    reportExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      reportExpanded = !reportExpanded;
                    });
                  },
                ),
                if (reportExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        ListTile(
                          minTileHeight: 0,
                          title: Text(
                            'Campaign Summary',
                            style: (TextStyles.Text15400 ?? const TextStyle())
                                .copyWith(color: Colors.white),
                          ),
                          onTap: () async {
                            _advancedDrawerController.hideDrawer();
                            await Future.delayed(
                              const Duration(milliseconds: 250),
                            );
                            Get.toNamed(AppRoutes.campaignSummary);
                          },
                        ),
                      ],
                    ),
                  ),
              ],

              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.bell,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Notifications',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () => Get.to(NotificationPage()),
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.eye,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Change Password',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () =>
                    Get.to(CreatePasswordScreen(email: email, flag: 2)),
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Delete Account',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  _advancedDrawerController.hideDrawer();
                  await Future.delayed(const Duration(milliseconds: 300));
                  final url = Uri.parse(
                    'https://benevolentrealty.com/delete-account',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Could not open Delete Account link.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              ListTile(
                minTileHeight: 0,
                leading: const Icon(
                  LucideIcons.logOut,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  'Logout',
                  style: (TextStyles.Text16400 ?? const TextStyle()).copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: _logout,
              ),
              const SizedBox(height: 25),
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
