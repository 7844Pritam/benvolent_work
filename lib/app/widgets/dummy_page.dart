import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  final String title;
  final int index;

  const DummyPage({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppThemes.primaryColor,
      ),
      body: const Center(
        child: Text('Dummy Page', style: TextStyle(fontSize: 20)),
      ),
      // bottomNavigationBar: BottomNavBarWidget(currentIndex: index),
    );
  }
}
