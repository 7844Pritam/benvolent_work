import 'package:benevolent_crm_app/app/modules/dashboard/views/dashboard.dart';
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
    ProfileScreen(),
    SettingsScreen(),
    SettingsScreen(),
    SettingsScreen(),
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

          return false; // Don't exit
        }
        return true; // Exit
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
