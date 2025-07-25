import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/modules/auth/views/create_password_screen.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  const VerifyScreen({Key? key, required this.email}) : super(key: key);
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();
  final auth = Get.find<AuthController>();

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
                            Icons.verified,
                            size: 60,
                            color: AppThemes.primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text('Verify OTP', style: TextStyles.Text13400),
                          SizedBox(height: 8),
                          Text(
                            'Enter OTP sent to your email',
                            style: TextStyles.Text13400,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          CustomInputField(
                            label: 'OTP',
                            controller: _otp,
                            validator: Validators.validateOTP,
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            text: 'Verify',
                            onPressed: auth.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      auth
                                          .verifyOTP(
                                            widget.email,
                                            _otp.text.trim(),
                                          )
                                          .then((_) {
                                            if (auth
                                                        .otpResponse
                                                        .value
                                                        ?.success ==
                                                    true &&
                                                auth
                                                        .otpResponse
                                                        .value
                                                        ?.message !=
                                                    "OTP is not correct.") {
                                              Get.to(
                                                () => CreatePasswordScreen(
                                                  email: widget.email,
                                                  flag: 1,
                                                ),
                                              );
                                            }
                                          });
                                    }
                                  },
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Terms & Privacy Policy apply',
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
