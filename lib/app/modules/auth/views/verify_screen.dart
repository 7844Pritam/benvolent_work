// import 'package:benevolent_crm_app/app/themes/text_styles.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../widgets/custom_input_field.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/text_styles.dart';

// class VerifyScreen extends StatefulWidget {
//   const VerifyScreen({super.key});

//   @override
//   State<VerifyScreen> createState() => _VerifyScreenState();
// }

// class _VerifyScreenState extends State<VerifyScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   String? _errorText = '58 sec • Resend OTP';

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
//             Text('Verify', style: TextStyles.heading),
//             const SizedBox(height: 8),
//             Text(
//               'We use OTP to Login or Register in to the App',
//               style: TextStyles.subheading,
//             ),
//             const SizedBox(height: 32),
//             CustomInputField(
//               label: 'Email ID',
//               controller: TextEditingController(text: 'Example@gmail.com'),
//               suffixIcon: Text('change', style: TextStyles.link),
//             ),
//             CustomInputField(
//               label: 'Enter OTP received',
//               obscureText: true,
//               controller: _otpController,
//               suffixIcon: const Icon(Icons.visibility_off),
//               errorText: _errorText,
//             ),
//             const SizedBox(height: 16),
//             CustomButton(
//               text: 'Verify',
//               onPressed: () {
//                 Get.offNamed('/dashboard'); // Navigate to dashboard
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
