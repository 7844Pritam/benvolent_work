import 'package:benevolent_crm_app/app/modules/cold_calls/views/cold_call_page.dart';
import 'package:benevolent_crm_app/app/modules/dashboard/views/dashboard.dart';
import 'package:benevolent_crm_app/app/modules/leads/view/all_leads_page.dart';

import 'package:benevolent_crm_app/app/modules/profile/view/profile_page.dart';

import 'package:benevolent_crm_app/app/widgets/bottom_nav_widget.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    AllLeadsPage(),
    ColdCallPage(),
    UserProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Rx<DateTime?> _lastBackPressTime = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastBackPressTime.value == null ||
            now.difference(_lastBackPressTime.value!) >
                const Duration(seconds: 2)) {
          _lastBackPressTime.value = now;

          CustomSnackbar.show(
            title: "Exit",
            message: "Press back again to exit",
            type: ToastType.warning,
          );

          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavBarWidget(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// Dummy Screens
