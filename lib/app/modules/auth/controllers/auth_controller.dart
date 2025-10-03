import 'package:benevolent_crm_app/app/modules/auth/modals/change_password_response.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/login_response_modal.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/otp_verify_response.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/reset_password_response.dart';
import 'package:benevolent_crm_app/app/services/auth_services.dart';
import 'package:benevolent_crm_app/app/utils/api_exceptions.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();

  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponseModel>();
  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("User granted permission: ${settings.authorizationStatus}");
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Ensure permissions are requested before fetching token
      await requestNotificationPermission();

      // Delete old token
      await FirebaseMessaging.instance.deleteToken();

      // iOS: wait for APNs token before fetching FCM token
      if (GetPlatform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        print("APNs Token: $apnsToken");
      }

      // Now get FCM token
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      print('New Device Token: $deviceToken');

      final data = await authService.login(email, password, deviceToken);

      loginResponse.value = data;

      CustomSnackbar.show(
        title: 'Login Successful',
        message: 'Welcome ${data.results.data.firstName}',
        type: ToastType.success,
      );

      Get.offAllNamed('/bottombar');
    } catch (e) {
      print('Login Failed Exception: $e');
      CustomSnackbar.show(
        title: 'Login Failed',
        message: e is ApiException ? e.message : e.toString(),
        type: ToastType.error,
      );
      loginResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Rxn<ResetPasswordResponse> resetResponse = Rxn<ResetPasswordResponse>();

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      final response = await authService.resetPassword(email);
      resetResponse.value = response;
      CustomSnackbar.show(
        title: response.success ? 'Reset Link Sent' : 'Reset Failed',
        message: response.message,
        type: ToastType.success,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Reset Failed',
        message: e is ApiException ? e.message : e.toString(),
        type: ToastType.error,
      );
      resetResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  var otpResponse = Rxn<OTPVerifyResponse>();
  var pwdResponse = Rxn<ChangePasswordResponse>();

  Future<void> verifyOTP(String email, String otp) async {
    try {
      isLoading.value = true;
      otpResponse.value = await authService.verifyOTP(email, otp);
      CustomSnackbar.show(
        title: 'Verify OTP',
        message: otpResponse.value!.message,
        type: ToastType.success,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String email, String pass, String confirm) async {
    print('change password');
    try {
      isLoading.value = true;
      pwdResponse.value = await authService.changePassword(
        email,
        pass,
        confirm,
      );
      print('change password1');
      print(pwdResponse.value);
      CustomSnackbar.show(
        title: 'Change Password',
        message: pwdResponse.value!.message,
        type: ToastType.success,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
