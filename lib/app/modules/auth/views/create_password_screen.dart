// import 'package:benevolent_crm_app/app/themes/text_styles.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../widgets/custom_input_field.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/text_styles.dart';

// class CreatePasswordScreen extends StatefulWidget {
//   const CreatePasswordScreen({super.key});

//   @override
//   State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
// }

// class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   String? _errorText;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B3946),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.home, size: 60, color: Color(0xFF0B3946)),
//             const SizedBox(height: 16),
//             Text('Create password', style: TextStyles.heading),
//             const SizedBox(height: 8),
//             Text(
//               'We use OTP to Login or Register in to the App',
//               style: TextStyles.subheading,
//             ),
//             const SizedBox(height: 32),
//             CustomInputField(
//               label: 'Password',
//               obscureText: true,
//               controller: _passwordController,
//               suffixIcon: const Icon(Icons.visibility_off),
//             ),
//             CustomInputField(
//               label: 'Confirm Password',
//               obscureText: true,
//               controller: _confirmPasswordController,
//               suffixIcon: const Icon(Icons.visibility_off),
//               errorText: _errorText,
//             ),
//             const SizedBox(height: 16),
//             CustomButton(
//               text: 'Verify',
//               onPressed: () {
//                 if (_passwordController.text !=
//                     _confirmPasswordController.text) {
//                   setState(() {
//                     _errorText = 'Password didn\'t match';
//                   });
//                 } else {
//                   Get.offNamed('/verify'); // Navigate to verify screen
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'By signing up I agree to the Terms and Conditions and Privacy Policy',
//               style: TextStyles.terms,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
