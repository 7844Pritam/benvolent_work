import 'package:benevolent_crm_app/app/modules/auth/views/verify_screen.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3946),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [SvgPicture.asset('assets/vectors/back.svg')]),
            SizedBox(height: 20),
            Center(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/Egg-Crm 1.png'),
                      const SizedBox(height: 16),
                      Text('Signup', style: TextStyles.Text23600),
                      const SizedBox(height: 8),
                      Text(
                        textAlign: TextAlign.center,
                        'We use OTP to Login or Register in to the App',
                        style: TextStyles.Text16400,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              label: 'First name',
                              controller: TextEditingController(
                                text: 'Example',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomInputField(
                              label: 'Last name',
                              controller: TextEditingController(
                                text: 'Example',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomInputField(
                        label: 'Email',
                        controller: TextEditingController(
                          text: 'Example@gmail.com',
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomInputField(label: 'Phone number'),
                      SizedBox(height: 10),
                      CustomInputField(label: 'Address'),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              "Or login with",
                              style: TextStyles.Text16400,
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
                      CustomButton(
                        isFilled: false,
                        text: 'Signup',
                        onPressed: () => Get.to(() => VerifyScreen(email: '')),
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
          ],
        ),
      ),
    );
  }
}
