import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      body: Padding(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/Egg-Crm 1.png'),
                  const SizedBox(height: 16),
                  Text('Login', style: TextStyles.Text23600),
                  const SizedBox(height: 8),
                  Text(
                    'We use OTP to Login or Register in to \nthe App',
                    style: TextStyles.Text16400,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomInputField(
                    label: 'Email ID',
                    controller: TextEditingController(
                      text: 'Example@gmail.com',
                    ),
                  ),
                  CustomInputField(
                    label: 'Password',
                    obscureText: true,
                    suffixIcon: const Icon(
                      Icons.visibility_off,
                      color: AppThemes.lightGreylittle,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyles.label.copyWith(
                          color: AppThemes.red,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Divider(
                          thickness: 1,
                          color: AppThemes.lightGreylittle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Or login with",
                          style: TextStyles.label.copyWith(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Divider(
                          thickness: 1,
                          color: AppThemes.lightGreylittle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // spacing: 10, // Remove spacing property, not valid for Row
                    children: [
                      Image.asset('assets/images/gmail.png'),
                      SizedBox(width: 10),
                      Image.asset('assets/images/skype.png'),
                      SizedBox(width: 10),
                      Image.asset('assets/images/yahoo.png'),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Signup',
                          isFilled: false,
                          onPressed: () => Get.toNamed('/signup'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Login',
                          onPressed: () => Get.toNamed('/verify'),
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
                        const TextSpan(text: 'By signing up I agree to the '),
                        TextSpan(
                          text: 'Terms  and \nConditions',
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
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
