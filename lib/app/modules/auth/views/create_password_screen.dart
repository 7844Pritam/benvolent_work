import 'package:benevolent_crm_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/utils/validators.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;
  const CreatePasswordScreen({Key? key, required this.email}) : super(key: key);
  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
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
                            Icons.lock,
                            size: 60,
                            color: AppThemes.primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text('Create Password', style: TextStyles.Text13400),
                          SizedBox(height: 8),
                          Text(
                            'Set a new password for your account',
                            style: TextStyles.Text13400,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          CustomInputField(
                            label: 'Password',
                            controller: _pass,
                            obscureText: true,
                            validator: Validators.validatePassword,
                          ),
                          SizedBox(height: 16),
                          CustomInputField(
                            label: 'Confirm Password',
                            controller: _confirm,
                            obscureText: true,
                            // validator: (v) =>
                            //     Validators.validateConfirmPassword(
                            //       _pass.text.trim(),
                            //       v,
                            //     ),
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            text: 'Submit',
                            onPressed: auth.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      auth
                                          .changePassword(
                                            widget.email,
                                            _pass.text.trim(),
                                            _confirm.text.trim(),
                                          )
                                          .then((_) {
                                            if (auth
                                                    .pwdResponse
                                                    .value
                                                    ?.success ??
                                                false) {
                                              Get.offAllNamed('/login');
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
