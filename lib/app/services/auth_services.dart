import 'package:benevolent_crm_app/app/modules/auth/modals/change_password_response.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/login_response_modal.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/otp_verify_response.dart';
import 'package:benevolent_crm_app/app/modules/auth/modals/reset_password_response.dart';
import 'package:benevolent_crm_app/app/services/api/api_client.dart';
import 'package:benevolent_crm_app/app/services/api/api_end_points.dart';
import 'package:benevolent_crm_app/app/utils/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  final ApiClient _apiClient;
  final box = GetStorage();

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LoginResponseModel> login(
    String email,
    String password,
    String? deviceToken,
  ) async {
    print("Device Token $deviceToken");
    try {
      print(email);
      print(password);
      final response = await _apiClient.post(
        ApiEndPoints.LOGIN_URL,
        data: {
          'email': email,
          'password': password,
          'device_token': deviceToken,
        },
      );

      final token = response.data['results']['token'];
      await _apiClient.setToken(token);
      box.write('token', token);
      box.write('isLoggedIn', true);

      final loginResponse = LoginResponseModel.fromJson(response.data);
      return loginResponse;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResetPasswordResponse> resetPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndPoints.RESET_PASSWORD_URL,
        data: {'email': email},
      );

      print("Reset password full response: ${response.data}");

      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<OTPVerifyResponse> verifyOTP(String email, String otp) async {
    final res = await _apiClient.post(
      ApiEndPoints.RESET_PASSWORD_VERIFY_URL,
      data: {'email': email, 'otp': otp},
    );
    return OTPVerifyResponse.fromJson(res.data);
  }

  Future<ChangePasswordResponse> changePassword(
    String email,
    String password,
    String confirm,
  ) async {
    final res = await _apiClient.post(
      ApiEndPoints.CHANGE_PASSWORD_URL,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': confirm,
      },
    );
    print(res.data);

    return ChangePasswordResponse.fromJson(res.data);
  }
}
