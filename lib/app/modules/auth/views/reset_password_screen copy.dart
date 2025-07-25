import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset('assets/vectors/back.svg'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.lock_reset,
                                size: 60,
                                color: AppThemes.primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Reset Password',
                                style: TextStyles.Text13400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We use OTP to reset your password',
                                style: TextStyles.Text13400,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              CustomInputField(
                                label: 'Email ID',
                                controller: _emailController,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Send OTP',
                                onPressed: authController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          authController.resetPassword(
                                            _emailController.text.trim(),
                                          );
                                        }
                                      },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'By proceeding, you agree to our Terms and Privacy Policy.',
                                style: TextStyles.terms,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Loader Overlay
              if (authController.isLoading.value)
                Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
