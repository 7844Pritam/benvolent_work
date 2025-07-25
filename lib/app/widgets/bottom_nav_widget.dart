import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: AppThemes.primaryColor,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Sales CRM',
        ),
      ],
    );
  }
}
