import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

class GlobalDrawerController extends GetxController {
  final advancedDrawerController = AdvancedDrawerController();

  void showDrawer() {
    advancedDrawerController.showDrawer();
  }

  void hideDrawer() {
    advancedDrawerController.hideDrawer();
  }

  void toggleDrawer() {
    advancedDrawerController.toggleDrawer();
  }

  @override
  void onClose() {
    advancedDrawerController.dispose();
    super.onClose();
  }
}
