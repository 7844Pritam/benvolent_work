import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/modules/auth/views/reset_password_screen.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(AuthController());
  bool _obscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Container(
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          Image.asset('assets/images/logo.png', width: 200),
                          const SizedBox(height: 16),
                          Text('Login', style: TextStyles.Text23600),
                          const SizedBox(height: 32),

                          /// ✅ Email Input
                          CustomInputField(
                            label: 'Email ID',
                            controller: emailController,
                            validator: Validators.validateEmail,
                          ),

                          /// 🔒 Password Input
                          CustomInputField(
                            label: 'Password',
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            validator: Validators.validatePassword,
                            suffixIcon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppThemes.lightGreylittle,
                            ),
                            onSuffixTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(ResetPasswordScreen()),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyles.label.copyWith(
                                    color: AppThemes.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          /// 🔘 Buttons
                          Row(
                            children: [
                              // Expanded(
                              //   child: CustomButton(
                              //     text: 'Signup',
                              //     isFilled: false,
                              //     onPressed: () => Get.toNamed('/signup'),
                              //   ),
                              // ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  text: 'Login',
                                  onPressed: loginController.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            loginController.login(
                                              emailController.text.trim(),
                                              passwordController.text,
                                            );
                                          }
                                        },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyles.terms.copyWith(
                                fontSize: 14,
                                color: AppThemes.lightGreylittle,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'By signing up I agree to the ',
                                ),
                                TextSpan(
                                  text: 'Terms and \nConditions',
                                  style: TextStyles.terms.copyWith(
                                    fontSize: 14,
                                    color: AppThemes.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyles.terms.copyWith(
                                    fontSize: 14,
                                    color: AppThemes.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Loader in center
            if (loginController.isLoading.value)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(year2023: true),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
