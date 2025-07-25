import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/modules/auth/views/verify_screen.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final auth = Get.put(AuthController());

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_reset,
                            size: 60,
                            color: AppThemes.primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text('Reset Password', style: TextStyles.Text13400),
                          SizedBox(height: 8),
                          Text(
                            'We will send OTP to your email',
                            style: TextStyles.Text13400,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          CustomInputField(
                            label: 'Email ID',
                            controller: _email,
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            text: 'Send OTP',
                            onPressed: auth.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      auth
                                          .resetPassword(_email.text.trim())
                                          .then((_) {
                                            if (auth
                                                    .resetResponse
                                                    .value
                                                    ?.success ??
                                                false) {
                                              Get.to(
                                                () => VerifyScreen(
                                                  email: _email.text.trim(),
                                                ),
                                              );
                                            }
                                          });
                                    }
                                  },
                          ),
                          SizedBox(height: 16),
                          Text(
                            'By proceeding you agree to our Terms & Privacy Policy',
                            style: TextStyles.terms,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (auth.isLoading.value) ...[
              Container(color: Colors.black45),
              Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
