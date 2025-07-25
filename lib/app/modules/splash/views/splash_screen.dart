import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../themes/app_themes.dart'; // Import themes

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AuthController loginController = Get.put(LoginController());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final loggedIn = box.read('isLoggedIn') ?? false;
      if (loggedIn) {
        Get.offAllNamed('/bottombar');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 32.0),
          //     child: Text(
          //       '09:32 PM IST',
          //       style: TextStyle(
          //         color: AppThemes.textColorPrimary,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
