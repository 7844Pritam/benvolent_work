import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final authController = Get.put(AuthController());

  bool termsAccepted = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  int currentStep = 1;

  Future<void> _openTerms() async {
    final url = Uri.parse("https://benevolentrealty.com/terms-conditions");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  Widget _buildStep1(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          const SizedBox(height: 6),
          CustomInputField(
            label: 'First Name *',
            controller: firstNameController,
            validator: (v) => v!.isEmpty ? 'Enter first name' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: 'Last Name',
            controller: lastNameController,
            validator: (v) => v!.isEmpty ? 'Enter last name' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: 'Phone *',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Enter phone number' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: 'Email (Username) *',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v!.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 28),
          CustomButton(
            isFilled: true,
            text: 'Next',
            onPressed: () {
              if (_formKey1.currentState!.validate()) {
                setState(() => currentStep = 2);
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Form(
      key: _formKey2,
      child: Column(
        children: [
          const SizedBox(height: 6),
          CustomInputField(
            label: 'Password *',
            controller: passwordController,
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
            validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: 'Confirm Password *',
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => setState(
                () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
              ),
            ),
            validator: (v) =>
                v != passwordController.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: termsAccepted,
                activeColor: AppThemes.primaryColor,
                onChanged: (v) => setState(() => termsAccepted = v ?? false),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyles.Text16400.copyWith(
                      color: AppThemes.lightGreylittle,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the Benevolent Realty '),
                      TextSpan(
                        text: 'Terms & Conditions *',
                        style: TextStyles.Text16400.copyWith(
                          color: AppThemes.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = _openTerms,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            isFilled: true,
            text: 'Signup',
            onPressed: () {
              if (_formKey2.currentState!.validate()) {
                if (!termsAccepted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please accept Terms & Conditions to continue',
                      ),
                    ),
                  );
                  return;
                }
                authController.signup(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  confirmPassword: confirmPasswordController.text.trim(),
                );
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B3946),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentStep == 2) {
                        setState(() => currentStep = 1);
                      } else {
                        Get.back();
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/vectors/back.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: width > 500 ? 450 : double.infinity,
                        padding: const EdgeInsets.all(20.0),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/logo.png', width: 150),
                            const SizedBox(height: 16),
                            Text('Signup', style: TextStyles.Text23600),
                            const SizedBox(height: 8),
                            Text(
                              currentStep == 1
                                  ? 'Create your account to continue'
                                  : 'Set your password and agree to terms',
                              style: TextStyles.Text16400,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),
                            AnimatedCrossFade(
                              firstChild: _buildStep1(context),
                              secondChild: _buildStep2(context),
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: currentStep == 1
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstCurve: Curves.easeInOut,
                              secondCurve: Curves.easeInOut,
                              sizeCurve: Curves.easeInOut,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (authController.isLoading.value) {
                return Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
